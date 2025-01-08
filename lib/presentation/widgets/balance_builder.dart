// ignore_for_file: must_be_immutable, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_store/bussines_logic/Cubit/Balance_Cubit/balance_cubit.dart';
import 'package:phone_store/data/firebase_data/data_balance_layer.dart';
import 'package:phone_store/data/models/balance_model.dart';
import 'package:phone_store/data/repository/balance_repository.dart';

import 'package:phone_store/presentation/widgets/button_builder.dart';
import 'package:phone_store/presentation/widgets/input_box.dart';

class BalanceBuilder extends StatelessWidget {
  final BalanceModel? balanceModel;
  DataBalanceLayer dataBalanceLayer = DataBalanceLayer();
  late BalanceRepository balanceRepository;

  TextEditingController typeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController profitController = TextEditingController();

  BalanceBuilder({super.key, this.balanceModel}) {
    if (balanceModel != null) {
      costController.text = balanceModel!.cost.toString();
      priceController.text = balanceModel!.price.toString();
      profitController.text = balanceModel!.profit.toString();
      typeController.text = balanceModel!.type.toString();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: balanceModel != null
          ? AppBar(
              backgroundColor: Colors.blueAccent,
              title: Center(
                  child: Text(
                "تعديل الرصيد",
                style: TextStyle(color: Colors.white),
              )),
            )
          : AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InputBox(
                  fieldName: "السعر",
                  controller: priceController,
                ),
                InputBox(
                  fieldName: "بيان",
                  controller: typeController,
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InputBox(
                  fieldName: "الربح",
                  controller: profitController,
                ),
                InputBox(
                  fieldName: "التكلفه",
                  controller: costController,
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            ButtonBuilder(
                buttonName: "شحن",
                onPressed: () {
                  balanceModel != null
                      ? _handleBalanceUpdate(context, balanceModel!)
                      : _handleBalanceAction(context);
                }),
          ],
        ),
      ),
    );
  }

  Future<void> _handleBalanceAction(BuildContext context) async {
    String type = typeController.text.trim();

    double? cost = double.tryParse(costController.text);
    double? price = double.tryParse(priceController.text);
    double? profit = double.tryParse(profitController.text);

    if (type.isEmpty ||
        costController.text.isEmpty ||
        priceController.text.isEmpty ||
        profitController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("الرجاء إدخال جميع الحقول بشكل صحيح"),
        ),
      );
      return;
    }

    if (cost == null ||
        cost <= 0 ||
        price == null ||
        price <= 0 ||
        profit == null ||
        profit <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("الرجاء إدخال عدد صالح"),
        ),
      );
      return;
    }

    try {
      BalanceModel balanceModel = BalanceModel(
        type: type,
        cost: cost,
        profit: profit,
        price: price,
        dateOfSale: DateTime.now(),
      );

      BlocProvider.of<BalanceCubit>(context).addBalance(balanceModel, context);

      _clearFields();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("خطأ: ${e.toString()}"),
        ),
      );
    }
  }

  Future<void> _handleBalanceUpdate(
      BuildContext context, BalanceModel balance) async {
    if (balance.docId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot update: docId is null")),
      );
      return;
    }
    String type = typeController.text.trim();
    double? cost = double.tryParse(costController.text);
    double? price = double.tryParse(priceController.text);
    double? profit = double.tryParse(profitController.text);

    if (type.isEmpty ||
        costController.text.isEmpty ||
        priceController.text.isEmpty ||
        profitController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("الرجاء إدخال جميع الحقول بشكل صحيح"),
        ),
      );
      return;
    }

    if (cost == null ||
        cost <= 0 ||
        price == null ||
        price <= 0 ||
        profit == null ||
        profit <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("الرجاء إدخال عدد صالح"),
        ),
      );
      return;
    }
    balanceRepository = BalanceRepository(dataBalanceLayer);
    final wallet = await balanceRepository.getBalanceById(balance.docId!);

    if (wallet == null) {
      print("Error: Wallet not found for docId ${balance.docId}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("لا توجد"),
        ),
      );
      return;
    }

    try {
      BalanceModel balanceModel = BalanceModel(
        docId: balance.docId,
        type: type,
        cost: cost,
        profit: profit,
        price: price,
        dateOfSale: DateTime.now(),
      );

      print("Updating BalanceModel: $balanceModel");

      bool removed = await BlocProvider.of<BalanceCubit>(context)
          .deleteBalanceRecord(balance.docId!, context);
      print("Delete operation successful: $removed");

      if (removed) {
        BlocProvider.of<BalanceCubit>(context)
            .addBalance(balanceModel, context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("تم تعديل الرصيد بنجاح"),
          ),
        );
        _clearFields();
      }
    } catch (e) {
      print("Error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("خطأ: ${e.toString()}"),
        ),
      );
    }
  }

  void _clearFields() {
    typeController.clear();
    profitController.clear();
    priceController.clear();
    costController.clear();
  }
}
