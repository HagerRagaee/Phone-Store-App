// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:phone_store/Classes/store_item_class.dart';
import 'package:phone_store/Data/data_inventory_layer.dart';
import 'package:phone_store/structure/button_builder.dart';
import 'package:phone_store/structure/input_box.dart';

class AddStoreItems extends StatefulWidget {
  AddStoreItems({super.key, StoreItem? store_item}) {
    if (store_item != null) {
      typeController.text = store_item.itemName;
      quantityController.text = store_item.quantity.toString();
      costController.text = store_item.itemCost.toString();
    }
  }

  TextEditingController typeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController costController = TextEditingController();

  @override
  State<AddStoreItems> createState() => _AddStoreItemsState();
}

class _AddStoreItemsState extends State<AddStoreItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'اضف الى المخزن',
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
                controller: widget.costController,
              ),
              InputBox(
                fieldName: "العدد",
                controller: widget.quantityController,
              ),
              InputBox(
                fieldName: "الصنف",
                controller: widget.typeController,
              ),
            ],
          ),
          SizedBox(height: 40),
          ButtonBuilder(
            buttonName: "أضف/عدل ألى المخزن",
            onPressed: () {
              String type = widget.typeController.text;
              int? quantity = int.tryParse(widget.quantityController.text);
              double? cost = double.tryParse(widget.costController.text);

              if (type.isEmpty || quantity == null || cost == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("الرجاء إدخال جميع الحقول بشكل صحيح")),
                );
                return;
              }

              StoreItem newItem = StoreItem(type, cost, quantity);
              FirebaseDatabase.saveOrUpdateStore(newItem);

              widget.typeController.clear();
              widget.quantityController.clear();
              widget.costController.clear();

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
