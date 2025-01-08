// ignore_for_file: unnecessary_import, deprecated_member_use, use_build_context_synchronously

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:phone_store/Functions/sales_function.dart';
import 'package:phone_store/bussines_logic/Cubit/Balance_Cubit/balance_cubit.dart';
import 'package:phone_store/bussines_logic/Cubit/Balance_Cubit/balance_state.dart';
import 'package:phone_store/bussines_logic/Cubit/Sales_Cubit/sales_cubit.dart';
import 'package:phone_store/bussines_logic/Cubit/Sales_Cubit/sales_state.dart';
import 'package:phone_store/bussines_logic/Cubit/Service_Cubit/service_cubit.dart';
import 'package:phone_store/bussines_logic/Cubit/Service_Cubit/service_state.dart';
import 'package:phone_store/data/firebase_data/data_balance_layer.dart';
import 'package:phone_store/data/models/balance_model.dart';
import 'package:phone_store/presentation/widgets/auth_button_builder.dart';
import 'package:phone_store/presentation/widgets/balance_card.dart';
import 'package:phone_store/presentation/widgets/sales_card.dart';
import 'package:phone_store/presentation/widgets/sales_excel_builder.dart';
import 'package:phone_store/presentation/widgets/service_card.dart';
import 'package:provider/provider.dart';

class ShowTodaysSales extends StatefulWidget {
  const ShowTodaysSales({super.key});

  @override
  State<ShowTodaysSales> createState() => _ShowTodaysSalesState();
}

class _ShowTodaysSalesState extends State<ShowTodaysSales> {
  List<DateTime?> _selectedDates = [];
  final DataBalanceLayer dataBalanceLayer = DataBalanceLayer();
  List<BalanceModel> balances = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SalesCubit>(context).getTodaySales();
    BlocProvider.of<ServiceCubit>(context).getTodayServices();
    balances = BlocProvider.of<BalanceCubit>(context).getTodayBalances();
    print(balances.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (BlocProvider.of<SalesCubit>(context).sales.isNotEmpty ||
                  BlocProvider.of<ServiceCubit>(context).services.isNotEmpty ||
                  balances.isNotEmpty) {
                SalesToExcel.createExcelFile(
                  BlocProvider.of<SalesCubit>(context).sales,
                  BlocProvider.of<ServiceCubit>(context).services,
                  BlocProvider.of<BalanceCubit>(context).balanceRecordes,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No data to export!')),
                );
              }
            },
            icon: Icon(
              Icons.open_in_browser,
              color: Colors.white,
            ),
          ),
        ],
        title: Center(
          child: Text(
            'تقرير المبيعات اليوميه',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 98, 182, 250),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              "التاريخ المحدد : ${_selectedDates.isEmpty ? '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}' : _selectedDates.map((date) => date!.toLocal().toString().split(' ')[0]).join(', ')}",
              style: TextStyle(fontSize: 19),
              textDirection: TextDirection.rtl,
            ),
            leading: IconButton(
              onPressed: () async {
                var results = await showCalendarDatePicker2Dialog(
                  context: context,
                  config: CalendarDatePicker2WithActionButtonsConfig(),
                  dialogSize: const Size(325, 200),
                  value: _selectedDates,
                  borderRadius: BorderRadius.circular(15),
                );
                if (results != null && results.isNotEmpty) {
                  setState(() {
                    _selectedDates = results;
                  });
                  BlocProvider.of<SalesCubit>(context)
                      .getSalesByDate(_selectedDates);
                  context
                      .read<ServiceCubit>()
                      .getServicesByDate(_selectedDates);

                  context.read<BalanceCubit>().getBalanceByDate(_selectedDates);
                }
              },
              icon: Icon(Icons.date_range),
            ),
          ),
          Expanded(
            child: BlocBuilder<SalesCubit, SalesState>(
              builder: (context, salesState) {
                return BlocBuilder<ServiceCubit, ServiceState>(
                  builder: (context, serviceState) {
                    return BlocBuilder<BalanceCubit, BalanceState>(
                        builder: (context, state) {
                      if (BlocProvider.of<SalesCubit>(context).sales.isEmpty &&
                          BlocProvider.of<ServiceCubit>(context)
                              .services
                              .isEmpty &&
                          BlocProvider.of<BalanceCubit>(context)
                              .balanceRecordes
                              .isEmpty) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (BlocProvider.of<SalesCubit>(context)
                              .sales
                              .isNotEmpty &&
                          BlocProvider.of<ServiceCubit>(context)
                              .services
                              .isEmpty &&
                          BlocProvider.of<BalanceCubit>(context)
                              .balanceRecordes
                              .isEmpty) {
                        return ListView(
                          children: [
                            SalesCard(),
                            SizedBox(height: 20),
                            CalculateTotalSales(),
                          ],
                        );
                      }
                      if (BlocProvider.of<ServiceCubit>(context)
                              .services
                              .isNotEmpty &&
                          (BlocProvider.of<SalesCubit>(context).sales.isEmpty &&
                              BlocProvider.of<BalanceCubit>(context)
                                  .balanceRecordes
                                  .isEmpty)) {
                        return ListView(
                          children: [
                            ServiceCard(),
                            SizedBox(height: 20),
                            CalculateTotalSales(),
                          ],
                        );
                      }
                      if (BlocProvider.of<ServiceCubit>(context)
                              .services
                              .isEmpty &&
                          (BlocProvider.of<SalesCubit>(context).sales.isEmpty &&
                              BlocProvider.of<BalanceCubit>(context)
                                  .balanceRecordes
                                  .isNotEmpty)) {
                        balances = BlocProvider.of<BalanceCubit>(context)
                            .balanceRecordes;

                        print(balances.length);
                        return ListView(
                          children: [
                            BalanceCard(),
                            SizedBox(height: 20),
                            CalculateTotalSales(),
                          ],
                        );
                      }

                      if (BlocProvider.of<ServiceCubit>(context)
                              .services
                              .isNotEmpty &&
                          (BlocProvider.of<SalesCubit>(context).sales.isEmpty &&
                              BlocProvider.of<BalanceCubit>(context)
                                  .balanceRecordes
                                  .isNotEmpty)) {
                        balances = BlocProvider.of<BalanceCubit>(context)
                            .balanceRecordes;

                        print(balances.length);
                        return ListView(
                          children: [
                            ServiceCard(),
                            SizedBox(height: 20),
                            BalanceCard(),
                            SizedBox(height: 20),
                            CalculateTotalSales(),
                          ],
                        );
                      }

                      if (BlocProvider.of<ServiceCubit>(context)
                              .services
                              .isEmpty &&
                          (BlocProvider.of<SalesCubit>(context)
                                  .sales
                                  .isNotEmpty &&
                              BlocProvider.of<BalanceCubit>(context)
                                  .balanceRecordes
                                  .isNotEmpty)) {
                        balances = BlocProvider.of<BalanceCubit>(context)
                            .balanceRecordes;

                        print(balances.length);
                        return ListView(
                          children: [
                            SalesCard(),
                            SizedBox(height: 20),
                            BalanceCard(),
                            SizedBox(height: 20),
                            CalculateTotalSales(),
                          ],
                        );
                      }

                      if (BlocProvider.of<ServiceCubit>(context)
                              .services
                              .isNotEmpty &&
                          (BlocProvider.of<SalesCubit>(context)
                                  .sales
                                  .isNotEmpty &&
                              BlocProvider.of<BalanceCubit>(context)
                                  .balanceRecordes
                                  .isEmpty)) {
                        return ListView(
                          children: [
                            SalesCard(),
                            SizedBox(height: 20),
                            ServiceCard(),
                            SizedBox(height: 20),
                            CalculateTotalSales(),
                          ],
                        );
                      }

                      return ListView(
                        children: [
                          SalesCard(),
                          SizedBox(height: 20),
                          ServiceCard(),
                          SizedBox(height: 20),
                          BalanceCard(),
                          SizedBox(height: 20),
                          CalculateTotalSales(),
                        ],
                      );
                    });
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class CalculateTotalSales extends StatefulWidget {
  const CalculateTotalSales({super.key});

  @override
  State<CalculateTotalSales> createState() => _CalculateTotalSalesState();
}

class _CalculateTotalSalesState extends State<CalculateTotalSales> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ButtonBuilder(
        buttonName: "مبيعات اليوم",
        click: () async {
          double totalSales = calculateTotalSales(context);
          double totalProfit = await calculateTotalProfit(context);

          Dialogs.materialDialog(
            dialogWidth: 300,
            color: Colors.white,
            msg:
                'اجمالي مبيعات: ${totalSales.toStringAsFixed(2)} \n اجمالي الربح:  ${totalProfit.toStringAsFixed(2)} ',
            title: 'Daily Sales',
            lottieBuilder: LottieBuilder.asset(
              'images/profit2.json',
              fit: BoxFit.contain,
            ),
            context: context,
            actions: [
              IconsButton(
                padding: EdgeInsets.all(20),
                onPressed: () {
                  Navigator.pop(context);
                },
                text: 'OK',
                iconData: Icons.done,
                color: Colors.blue,
                textStyle: const TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
            ],
          );
        },
      ),
    );
  }
}
