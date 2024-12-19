import 'package:flutter/material.dart';
import 'package:phone_store/Classes/sales_class.dart';

import 'package:phone_store/Data/data_sales_layer.dart';
import 'package:phone_store/structure/button_builder.dart';
import 'package:phone_store/structure/input_box.dart';

Widget sellItemBuilder(BuildContext context) {
  TextEditingController typeController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  TextEditingController quantityController = TextEditingController();
  return Padding(
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
              fieldName: "العدد",
              controller: quantityController,
            ),
            InputBox(
              fieldName: "الصنف",
              controller: typeController,
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        ButtonBuilder(
          buttonName: "بيع",
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
              String id = type + DateTime.now().toString();
              SaleRecord sale = SaleRecord(
                id: id,
                dateOfSale: DateTime.now(),
                itemName: type,
                quantitySold: quantity,
                salePrice: double.tryParse(priceController.text)! * quantity,
              );

              await FirebaseOperations.saveSaleRecord(sale, context);

              // Clear the inputs after successful sale
              typeController.clear();
              quantityController.clear();
              priceController.clear();
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
  );
}
