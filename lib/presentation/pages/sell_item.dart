import 'package:flutter/material.dart';
import '../widgets/balance_builder.dart';
import '../widgets/sell_item_builder.dart';
import '../widgets/service_builder.dart';

class SellItem extends StatefulWidget {
  SellItem({super.key});

  @override
  State<SellItem> createState() => _SellItemState();
}

class _SellItemState extends State<SellItem> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  "اكسسوار",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "كاش",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "رصيد",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 98, 182, 250),
        ),
        body: TabBarView(
          children: [SellItemBuilder(), ServiceBuilder(), BalanceBuilder()],
        ),
      ),
    );
  }
}
