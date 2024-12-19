import 'package:flutter/material.dart';
import 'package:phone_store/Classes/store_item_class.dart';
import 'package:phone_store/Data/data_inventory_layer.dart';
import 'package:phone_store/structure/button_builder.dart';
import 'package:phone_store/structure/input_box.dart';

class AddStoreItems extends StatefulWidget {
  const AddStoreItems({super.key});

  @override
  State<AddStoreItems> createState() => _AddStoreItemsState();
}

class _AddStoreItemsState extends State<AddStoreItems> {
  TextEditingController typeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Add Store Items',
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InputBox(
                fieldName: "التكلفه",
                controller: costController,
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
          SizedBox(height: 40),
          ButtonBuilder(
            buttonName: "أضف/عدل ألى المخزن",
            onPressed: () {
              String type = typeController.text;
              int? quantity = int.tryParse(quantityController.text);
              // double? price = double.tryParse(priceController.text);
              double? cost = double.tryParse(costController.text);

              if (type.isEmpty || quantity == null || cost == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("الرجاء إدخال جميع الحقول بشكل صحيح")),
                );
                return;
              }

              StoreItem newItem = StoreItem(type, cost, quantity);
              FirebaseDatabase.saveOrUpdateStore(newItem);

              typeController.clear();
              quantityController.clear();
              costController.clear();
              priceController.clear();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("تم إضافة/تعديل الصنف بنجاح")),
              );
            },
          )
        ],
      ),
    );
  }
}
