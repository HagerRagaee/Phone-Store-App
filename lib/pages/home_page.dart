import 'package:flutter/material.dart';
import 'package:phone_store/Statemangement/provider_store_class.dart';
import 'package:phone_store/pages/add_store_items.dart';
import 'package:phone_store/pages/sell_item.dart';
import 'package:phone_store/pages/show_inventory_items.dart';
import 'package:phone_store/pages/show_today%60s_sales.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      SellItem(),
      ShowTodaysSales(),
      AddStoreItems(),
      ShowInventoryItems()
    ];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Consumer<ProvStore>(
          builder: (context, prov, child) {
            return pages[prov.selectedIndex];
          },
        ),
      ),
      bottomNavigationBar: Consumer<ProvStore>(
        builder: (context, prov, child) {
          return BottomNavigationBar(
            selectedItemColor: Colors.purple,
            currentIndex: prov.selectedIndex,
            onTap: (index) => prov.onTappedItem(index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.sell, color: Colors.purple),
                label: 'Sell Item',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.attach_money, color: Colors.purple),
                label: 'Sales',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory, color: Colors.purple),
                label: 'Add to Store',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.store, color: Colors.purple),
                label: 'Inventory',
              ),
            ],
          );
        },
      ),
    );
  }
}
