// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_store/data/models/sales_class.dart';
import 'package:phone_store/bussines_logic/Cubit/Sales_Cubit/sales_cubit.dart';
import 'package:phone_store/presentation/widgets/button_builder.dart';
import 'package:phone_store/presentation/widgets/input_box.dart';

class BalanceBuilder extends StatefulWidget {
  @override
  State<BalanceBuilder> createState() => _BalanceBuilderState();

  TextEditingController typeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController profitController = TextEditingController();
}

class _BalanceBuilderState extends State<BalanceBuilder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  controller: widget.priceController,
                ),
                InputBox(
                  fieldName: "بيان",
                  controller: widget.typeController,
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
                  controller: widget.profitController,
                ),
                InputBox(
                  fieldName: "التكلفه",
                  controller: widget.costController,
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            ButtonBuilder(
              buttonName: "شحن",
              onPressed: () async {
                String type = widget.typeController.text.trim();
                String quantityText = widget.costController.text.trim();

                if (type.isEmpty || quantityText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("الرجاء إدخال جميع الحقول بشكل صحيح"),
                    ),
                  );
                  return;
                }

                int? quantity = int.tryParse(quantityText);
                if (quantity == null || quantity <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("الرجاء إدخال عدد صالح"),
                    ),
                  );
                  return;
                }
                // try {
                //   String id = type + DateTime.now().toString();
                //   SaleRecord sale = SaleRecord(
                //     id: id,
                //     dateOfSale: DateTime.now(),
                //     itemName: type,
                //     quantitySold: quantity,
                //     salePrice: double.tryParse(widget.priceController.text)!,
                //   );

                //   await FirebaseOperations.saveSaleRecord(sale, context);

                //   widget.typeController.clear();
                //   widget.costController.clear();
                //   widget.priceController.clear();
                // } catch (e) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text("خطأ: ${e.toString()}"),
                //     ),
                //   );
                // }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget updateWidget(
  BuildContext context,
  TextEditingController typeController,
  TextEditingController priceController,
  TextEditingController costController,
  SaleRecord item,
) {
  return ButtonBuilder(
    buttonName: "حفظ وتعديل",
    onPressed: () async {
      String type = typeController.text.trim();
      String quantityText = costController.text.trim();

      if (type.isEmpty || quantityText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("الرجاء إدخال جميع الحقول بشكل صحيح"),
          ),
        );
        return;
      }

      int? quantity = int.tryParse(quantityText);
      if (quantity == null || quantity <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("الرجاء إدخال عدد صالح"),
          ),
        );
        return;
      }
      try {
        String id = item.id;
        SaleRecord sale = SaleRecord(
          id: id,
          dateOfSale: item.dateOfSale,
          itemName: type,
          quantitySold: quantity,
          salePrice: double.tryParse(priceController.text)!,
        );

        BlocProvider.of<SalesCubit>(context)
            .updateSaleRecord(item, sale, context);

        typeController.clear();
        costController.clear();
        priceController.clear();
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("خطأ: ${e.toString()}"),
          ),
        );
      }
    },
  );
}
