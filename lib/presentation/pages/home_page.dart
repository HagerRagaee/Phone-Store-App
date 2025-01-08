import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:phone_store/Functions/tabs_navigator.dart';
import 'package:phone_store/presentation/pages/add_store_items.dart';
import 'package:phone_store/presentation/pages/sell_item.dart';
import 'package:phone_store/presentation/pages/show_inventory_items.dart';
import 'package:phone_store/presentation/pages/show_today%60s_sales.dart';
import 'package:phone_store/presentation/pages/wallet_page.dart';
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
      ShowInventoryItems(),
      WalletPage(),
    ];

    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        backgroundColor: const Color.fromARGB(255, 250, 248, 248),
        activeColor: Colors.black,
        height: 60,
        top: -12,
        items: [
          TabItem(
            icon: Icon(
              Icons.sell,
              color: Colors.purple,
              size: 30,
            ),
            title: 'بيع',
          ),
          TabItem(
            icon: Icon(
              Icons.attach_money,
              color: Colors.purple,
              size: 30,
            ),
            title: 'المبيعات',
          ),
          TabItem(
            icon: Icon(
              Icons.inventory,
              color: Colors.purple,
              size: 30,
            ),
            title: 'اضف الى المخزن',
          ),
          TabItem(
            icon: Icon(
              Icons.store,
              color: Colors.purple,
              size: 30,
            ),
            title: 'المخزن',
          ),
          TabItem(
            icon: Icon(
              Icons.wallet,
              color: Colors.purple,
              size: 30,
            ),
            title: 'المحافظ',
          ),
        ],
        initialActiveIndex: Provider.of<ProvStore>(context).selectedIndex,
        onTap: (index) {
          Provider.of<ProvStore>(context, listen: false).onTappedItem(index);
        },
      ),
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Consumer<ProvStore>(
          builder: (context, prov, child) {
            return pages[prov.selectedIndex];
          },
        ),
      ),
    );
  }
}
