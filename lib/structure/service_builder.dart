// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_store/Classes/service_class.dart';
import 'package:phone_store/Data/data_wallet_layer.dart';
import 'package:phone_store/Statemangement/Cubit/Service_Cubit/service_cubit.dart';
import 'package:phone_store/structure/button_builder.dart';
import 'package:phone_store/structure/input_box.dart';

class ServiceBuilder extends StatelessWidget {
  ServiceBuilder({super.key, this.service}) {
    if (service != null) {
      typeController.text = service!.serviceType;
      numberController.text = service!.phoneNumber;
      amountController.text = service!.money.toString();
      costController.text = service!.cost.toString();
    }
  }

  final ServiceRecord? service;

  final TextEditingController numberController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController costController = TextEditingController();

  Future<List<String>> getPhoneNumbers() async {
    final walletDataList = await DataWalletLayer.getAllWallet();
    return walletDataList.map((wallet) => wallet.phoneNumber).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: service != null
          ? AppBar(
              backgroundColor: Colors.blueAccent,
              title: Center(
                  child: Text(
                "تعديل خدمة",
                style: TextStyle(color: Colors.white),
              )),
            )
          : AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InputBox(
                      fieldName: "نوع الخدمة",
                      controller: typeController,
                      items: ["سحب", "إيداع"],
                    ),
                    if (numberController.text.isEmpty)
                      FutureBuilder<List<String>>(
                        future: getPhoneNumbers(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Text("Error loading phone numbers");
                          } else if (snapshot.data == null ||
                              snapshot.data!.isEmpty) {
                            return const Text("No phone numbers available");
                          } else {
                            return InputBox(
                              fieldName: "رقم المحفظة",
                              controller: numberController,
                              drop: true,
                              items: snapshot.data!,
                            );
                          }
                        },
                      )
                    else
                      InputBox(
                        fieldName: "رقم المحفظة",
                        controller: numberController,
                        items: [],
                      ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InputBox(
                      fieldName: "التكلفة",
                      controller: costController,
                    ),
                    InputBox(
                      fieldName: "المبلغ المحول",
                      controller: amountController,
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                ButtonBuilder(
                  buttonName: "سحب/إيداع",
                  onPressed: () => service != null
                      ? _handleServiceUpdate(context, service!)
                      : _handleServiceAction(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleServiceAction(BuildContext context) async {
    String type = typeController.text.trim();
    String phoneNumber = numberController.text.trim();
    String amountText = amountController.text.trim();
    String costText = costController.text.trim();

    if (type.isEmpty ||
        phoneNumber.isEmpty ||
        amountText.isEmpty ||
        costText.isEmpty) {
      _showSnackBar(context, "الرجاء إدخال جميع الحقول بشكل صحيح");
      return;
    }

    final amount = double.tryParse(amountText);
    final cost = double.tryParse(costText);

    if (amount == null || amount <= 0) {
      _showSnackBar(context, "الرجاء إدخال مبلغ صالح");
      return;
    }

    final wallet = await DataWalletLayer.getWalletById(phoneNumber);

    if (wallet == null) {
      _showSnackBar(context, "رقم المحفظة غير موجود");
      return;
    }

    if (type == "إيداع" && (wallet.walletLimit ?? 200000.0) < amount) {
      _showSnackBar(context, "المبلغ الإجمالي سيتجاوز الحد الأقصى");
      return;
    }

    try {
      final serviceRecord = ServiceRecord(
        cost: cost ?? 0.0,
        money: amount,
        phoneNumber: phoneNumber,
        serviceType: type,
        walletId: phoneNumber,
      );

      BlocProvider.of<ServiceCubit>(context).addService(serviceRecord, context);
      await DataWalletLayer.updateWallet(
          phoneNumber, amount, cost ?? 0.0, type, context);

      _clearFields();
    } catch (e) {
      _showSnackBar(context, "خطأ: ${e.toString()}");
    }
  }

  Future<void> _handleServiceUpdate(
      BuildContext context, ServiceRecord service) async {
    String type = typeController.text.trim();
    String phoneNumber = numberController.text.trim();
    String amountText = amountController.text.trim();
    String costText = costController.text.trim();

    if (type.isEmpty ||
        phoneNumber.isEmpty ||
        amountText.isEmpty ||
        costText.isEmpty) {
      _showSnackBar(context, "الرجاء إدخال جميع الحقول بشكل صحيح");
      return;
    }

    final amount = double.tryParse(amountText);
    final cost = double.tryParse(costText);

    if (amount == null || amount <= 0) {
      _showSnackBar(context, "الرجاء إدخال مبلغ صالح");
      return;
    }

    final wallet = await DataWalletLayer.getWalletById(phoneNumber);

    if (wallet == null) {
      _showSnackBar(context, "رقم المحفظة غير موجود");
      return;
    }

    if (type == "إيداع" && (wallet.walletLimit ?? 200000.0) < amount) {
      _showSnackBar(context, "المبلغ الإجمالي سيتجاوز الحد الأقصى");
      return;
    }

    try {
      final serviceRecord = ServiceRecord(
        cost: cost ?? 0.0,
        money: amount,
        phoneNumber: phoneNumber,
        serviceType: type,
        walletId: phoneNumber,
      );

      await BlocProvider.of<ServiceCubit>(context)
          .removeService(service.docId!, context);

      await BlocProvider.of<ServiceCubit>(context)
          .addService(serviceRecord, context);

      await DataWalletLayer.updateWallet(
          phoneNumber, amount, cost ?? 0.0, type, context);

      _clearFields();
    } catch (e) {
      _showSnackBar(context, "خطأ: ${e.toString()}");
    }
  }

  void _clearFields() {
    typeController.clear();
    numberController.clear();
    amountController.clear();
    costController.clear();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
