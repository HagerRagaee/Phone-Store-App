// ignore_for_file: unnecessary_import

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:phone_store/Functions/sales_function.dart';
import 'package:phone_store/Statemangement/Cubit/Sales_Cubit/sales_cubit.dart';
import 'package:phone_store/Statemangement/Cubit/Sales_Cubit/sales_state.dart';
import 'package:phone_store/Statemangement/Cubit/Service_Cubit/service_cubit.dart';
import 'package:phone_store/Statemangement/Cubit/Service_Cubit/service_state.dart';
import 'package:phone_store/structure/auth_button_builder.dart';
import 'package:phone_store/structure/sales_card.dart';
import 'package:phone_store/structure/sales_excel_builder.dart';
import 'package:phone_store/structure/service_card.dart';
import 'package:provider/provider.dart';

class ShowTodaysSales extends StatefulWidget {
  const ShowTodaysSales({super.key});

  @override
  State<ShowTodaysSales> createState() => _ShowTodaysSalesState();
}

class _ShowTodaysSalesState extends State<ShowTodaysSales> {
  List<DateTime?> _selectedDates = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SalesCubit>(context).fetchTodaySales();
    BlocProvider.of<ServiceCubit>(context).fetchTodayService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (BlocProvider.of<SalesCubit>(context).items.isNotEmpty ||
                  BlocProvider.of<ServiceCubit>(context).services.isNotEmpty) {
                SalesToExcel.createExcelFile(
                    BlocProvider.of<SalesCubit>(context).items,
                    BlocProvider.of<ServiceCubit>(context).services);
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
                  dialogSize: const Size(325, 400),
                  value: _selectedDates,
                  borderRadius: BorderRadius.circular(15),
                );
                if (results != null && results.isNotEmpty) {
                  setState(() {
                    _selectedDates = results;
                  });
                  await BlocProvider.of<SalesCubit>(context)
                      .fetchSalesForDates(_selectedDates);
                  context
                      .read<ServiceCubit>()
                      .fetchServicesForDates(_selectedDates);
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
                    if (BlocProvider.of<SalesCubit>(context).items.isEmpty &&
                        BlocProvider.of<ServiceCubit>(context)
                            .services
                            .isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (BlocProvider.of<SalesCubit>(context).items.isNotEmpty &&
                        BlocProvider.of<ServiceCubit>(context)
                            .services
                            .isEmpty) {
                      return ListView(
                        children: [
                          SalesCard(),
                          SizedBox(height: 40),
                          CalculateTotalSales(),
                        ],
                      );
                    }
                    if (BlocProvider.of<ServiceCubit>(context)
                            .services
                            .isNotEmpty &&
                        (BlocProvider.of<SalesCubit>(context).items.isEmpty)) {
                      return ListView(
                        children: [
                          ServiceCard(),
                          SizedBox(height: 40),
                          CalculateTotalSales(),
                        ],
                      );
                    }

                    return ListView(
                      children: [
                        SalesCard(),
                        SizedBox(height: 40),
                        ServiceCard(),
                        SizedBox(height: 60),
                        CalculateTotalSales(),
                      ],
                    );
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
  CalculateTotalSales({super.key});

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

          Dialogs.materialDialog(
            dialogWidth: 300,
            color: Colors.white,
            msg: 'اجمالي مبيعات: ${totalSales.toStringAsFixed(2)}',
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
