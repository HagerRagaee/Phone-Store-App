import 'package:flutter/material.dart';
import 'package:phone_store/Data/data_inventory_layer.dart';
import 'package:phone_store/structure/card_builder.dart';
import 'package:phone_store/structure/excel_builder.dart';
import 'package:phone_store/Classes/store_item_class.dart';

class ShowInventoryItems extends StatefulWidget {
  const ShowInventoryItems({super.key});

  @override
  State<ShowInventoryItems> createState() => _ShowInventoryItemsState();
}

class _ShowInventoryItemsState extends State<ShowInventoryItems> {
  List<StoreItem> _items = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // Call the method to fetch data asynchronously
  }

  Future<void> fetchData() async {
    try {
      final items = await FirebaseDatabase.getAllStores(); // Await the Future
      setState(() {
        _items = items; // Update the state with the fetched list
      });
    } catch (e) {
      print('Error fetching items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (_items.isNotEmpty) {
                InventoryToExcel.createExcelFile(_items);
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
            'Inventory Items',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 98, 182, 250),
      ),
      body: _items.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [InventoryCard(items: _items)],
            ),
    );
  }
}
