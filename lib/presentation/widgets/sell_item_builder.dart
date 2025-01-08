// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_store/data/models/sales_class.dart';
import 'package:phone_store/bussines_logic/Cubit/Sales_Cubit/sales_cubit.dart';
import 'package:phone_store/presentation/widgets/button_builder.dart';
import 'package:phone_store/presentation/widgets/input_box.dart';

class SellItemBuilder extends StatefulWidget {
  SellItemBuilder({super.key, this.item, this.update}) {
    if (item != null) {
      priceController.text = item!.salePrice.toString();
      quantityController.text = item!.quantitySold.toString();
      typeController.text = item!.itemName;
      date = DateTime(
          item!.dateOfSale.year, item!.dateOfSale.month, item!.dateOfSale.day);
    }
  }
  final SaleRecord? item;
  final bool? update;
  DateTime? date;

  @override
  State<SellItemBuilder> createState() => _SellItemBuilderState();

  TextEditingController typeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
}

class _SellItemBuilderState extends State<SellItemBuilder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.update != null && widget.update == true
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blue,
              actions: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        textDirection: TextDirection.rtl,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        BlocProvider.of<SalesCubit>(context)
                            .getSalesByOneDate(widget.date);
                      },
                    ),
                  ],
                )
              ],
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: InputBox(
                    fieldName: "السعر",
                    controller: widget.priceController,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: InputBox(
                    fieldName: "العدد",
                    controller: widget.quantityController,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: InputBox(
                    fieldName: "الصنف",
                    controller: widget.typeController,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            widget.update != null && widget.update == true
                ? updateWidget(
                    context,
                    widget.typeController,
                    widget.priceController,
                    widget.quantityController,
                    widget.item!)
                : ButtonBuilder(
                    buttonName: "بيع",
                    onPressed: () async {
                      String type = widget.typeController.text.trim();
                      String quantityText =
                          widget.quantityController.text.trim();

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
                        String id = type + DateTime.now().toString();
                        SaleRecord sale = SaleRecord(
                          id: id,
                          dateOfSale: DateTime.now(),
                          itemName: type,
                          quantitySold: quantity,
                          salePrice:
                              double.tryParse(widget.priceController.text)!,
                        );
                        BlocProvider.of<SalesCubit>(context)
                            .saveSaleRecord(sale, context);

                        widget.typeController.clear();
                        widget.quantityController.clear();
                        widget.priceController.clear();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("خطأ: ${e.toString()}"),
                          ),
                        );
                      }
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
  TextEditingController quantityController,
  SaleRecord item,
) {
  return ButtonBuilder(
    buttonName: "حفظ وتعديل",
    onPressed: () async {
      String type = typeController.text.trim();
      String quantityText = quantityController.text.trim();

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
        quantityController.clear();
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
