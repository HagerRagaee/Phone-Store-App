import 'package:flutter/material.dart';
import 'package:phone_store/structure/sell_item_builder.dart';
import 'package:phone_store/structure/service_builder.dart';

class SellItem extends StatefulWidget {
  SellItem({super.key});

  @override
  State<SellItem> createState() => _SellItemState();
}

class _SellItemState extends State<SellItem> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  "Sell Item",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "Service",
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
          children: [sellItemBuilder(context), serviceBuilder(context)],
        ),
      ),
    );
  }
}
