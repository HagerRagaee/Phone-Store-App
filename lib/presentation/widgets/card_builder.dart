import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:phone_store/data/firebase_data/data_inventory_layer.dart';
import 'package:phone_store/data/models/store_item_class.dart';
import 'package:phone_store/presentation/pages/add_store_items.dart';

class InventoryCard extends StatefulWidget {
  final List<StoreItem> items;

  InventoryCard({required this.items});

  @override
  State<InventoryCard> createState() => _InventoryCardState();
}

class _InventoryCardState extends State<InventoryCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header for the "Excel-like" layout
            Table(
              border: TableBorder.all(
                color: Colors.grey,
                width: 1,
              ),
              textDirection:
                  TextDirection.rtl, // Set the table's direction to RTL
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Lighter header background
                  ),
                  children: [
                    _buildTableCell('الصنف', isHeader: true),
                    _buildTableCell('الكمية', isHeader: true),
                    _buildTableCell('التكلفه', isHeader: true),
                  ],
                ),
                // Dynamically generate rows based on the items list
                for (var item in widget.items)
                  TableRow(
                    children: [
                      _buildClickableTableCell(item.itemName, item, context),
                      _buildClickableTableCell(
                          item.quantity.toString(), item, context),
                      _buildClickableTableCell(
                          '${item.itemCost}', item, context),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClickableTableCell(
      String text, StoreItem item, BuildContext context) {
    final FirebaseDatabase firebaseDatabase = FirebaseDatabase();
    return InkWell(
      onTap: () {
        Dialogs.materialDialog(
          dialogWidth: 300,
          color: Colors.white,
          msg: 'Are you sure you want to delete ${item.itemName}?',
          title: 'Delete item',
          lottieBuilder: LottieBuilder.asset(
            'images/delete.json',
            fit: BoxFit.contain,
          ),
          context: context,
          actions: [
            IconsButton(
              padding: EdgeInsets.all(20),
              onPressed: () {
                firebaseDatabase.deleteItem(item.itemName);
                Navigator.pop(context); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Deleted successfully")),
                );
              },
              text: 'Delete',
              color: Colors.red,
              textStyle: const TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
            IconsButton(
              padding: EdgeInsets.all(20),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddStoreItems(
                      store_item: item,
                    ),
                  ),
                );
              },
              text: 'Update',
              color: Colors.blue,
              textStyle: const TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ],
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54, // Adjust text color
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl, // Ensure text is RTL
        ),
      ),
    );
  }

  // Helper method to build the header cells
  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isHeader ? 16 : 14,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color:
              isHeader ? Colors.black87 : Colors.black54, // Adjust text color
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl, // Ensure text is RTL
      ),
    );
  }
}
