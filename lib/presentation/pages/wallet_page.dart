import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_store/bussines_logic/Cubit/Wallet_Cubit/wallet_cubit.dart';
import 'package:phone_store/presentation/pages/add_service.dart';
import 'package:phone_store/presentation/widgets/wallet_card.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    super.initState();
    // Fetch wallet data when the page is initialized
    BlocProvider.of<WalletCubit>(context).getAllWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallets'),
        actions: [
          Row(
            children: [
              const Text(
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
                  MaterialPageRoute(builder: (context) => const AddService()),
                ),
              ),
            ],
          )
        ],
      ),
      body: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          if (state is WalletInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WalletFailure) {
            return Center(child: Text('خطأ: ${state.errorMessage}'));
          } else if (state is WalletFetched) {
            final walletList = state.Wallet;

            if (walletList.isEmpty) {
              return const Center(child: Text('لا توجد محافظ متاحة.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: walletList.length,
              itemBuilder: (context, index) {
                final wallet = walletList[index];

                return WalletCard(wallet: wallet);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
