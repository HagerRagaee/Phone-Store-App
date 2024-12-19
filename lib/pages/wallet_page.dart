import 'package:flutter/material.dart';
import 'package:phone_store/Classes/wallet_class.dart';
import 'package:phone_store/Data/data_wallet_layer.dart';
import 'package:phone_store/pages/add_service.dart';
import 'package:phone_store/structure/wallet_card.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late Future<List<WalletData>> wallets;

  @override
  void initState() {
    super.initState();
    setState(() {
      wallets = DataWalletLayer.getAllWallet(); // Fetch wallet data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallets'),
        actions: [
          Row(
            children: [
              Text(
                "Add Wallet",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddService()),
                ),
              ),
            ],
          )
        ],
      ),
      body: FutureBuilder<List<WalletData>>(
        future: wallets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد محافظ.'));
          }

          final walletList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: walletList.length,
            itemBuilder: (context, index) {
              final wallet = walletList[index];

              return WalletCard(wallet: wallet);
            },
          );
        },
      ),
    );
  }
}
