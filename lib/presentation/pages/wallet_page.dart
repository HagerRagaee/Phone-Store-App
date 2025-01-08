import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_store/bussines_logic/Cubit/Wallet_Cubit/wallet_cubit.dart';
import 'package:phone_store/data/firebase_data/data_wallet_layer.dart';
import 'package:phone_store/data/models/wallet_class.dart';
import 'package:phone_store/data/repository/wallet_repository.dart';
import 'package:phone_store/presentation/widgets/wallet_card.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final TextEditingController searchController = TextEditingController();
  late DataWalletLayer dataWalletLayer;
  late WalletRepository walletRepository;
  late WalletCubit walletCubit;
  List<WalletData> result = [];

  @override
  void initState() {
    super.initState();
    dataWalletLayer = DataWalletLayer();
    walletRepository = WalletRepository(dataWalletLayer);
    walletCubit = WalletCubit(walletRepository);
    searchController.addListener(listener);
    BlocProvider.of<WalletCubit>(context).getAllWallet();
  }

  void listener() async {
    final query = searchController.text;
    if (query.isNotEmpty) {
      final searchedWallets = await walletCubit.searchWallet(query);
      setState(() {
        result = searchedWallets;
      });
    } else {
      setState(() {
        result = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CupertinoSearchTextField(
          controller: searchController,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/addWallet');
            },
          ),
        ],
      ),
      body: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          if (state is WalletInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WalletFailure) {
            return Center(child: Text('خطأ: ${state.errorMessage}'));
          } else if (state is WalletFetched) {
            var walletList =
                searchController.text.isNotEmpty ? result : state.Wallet;

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
