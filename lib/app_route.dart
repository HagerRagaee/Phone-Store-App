// ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_store/bussines_logic/Cubit/Sales_Cubit/sales_cubit.dart';
import 'package:phone_store/bussines_logic/Cubit/Service_Cubit/service_cubit.dart';
import 'package:phone_store/bussines_logic/Cubit/Wallet_Cubit/wallet_cubit.dart';
import 'package:phone_store/data/firebase_data/data_sales_layer.dart';
import 'package:phone_store/data/firebase_data/data_service_layer.dart';
import 'package:phone_store/data/firebase_data/data_wallet_layer.dart';
import 'package:phone_store/data/repository/sales_repository.dart';
import 'package:phone_store/data/repository/service_repository.dart';
import 'package:phone_store/data/repository/wallet_repository.dart';
import 'package:phone_store/presentation/pages/add_wallet.dart';
import 'package:phone_store/presentation/pages/home_page.dart';
import 'package:phone_store/presentation/pages/wallet_page.dart';

class AppRoute {
  late ServiceRepository serviceRepository;
  late WalletRepository walletRepository;
  late SalesRepository salesRepository;

  late ServiceCubit serviceCubit;
  late WalletCubit walletCubit;
  late SalesCubit salesCubit;

  AppRoute() {
    serviceRepository = ServiceRepository(DataServiceLayer());
    walletRepository = WalletRepository(DataWalletLayer());
    salesRepository = SalesRepository(FirebaseOperations());
  }

  Route? generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) => ServiceCubit(serviceRepository)),
              BlocProvider(create: (context) => SalesCubit(salesRepository)),
              BlocProvider(create: (context) => WalletCubit(walletRepository)),
            ],
            child: HomePage(),
          ),
        );

      case '/wallet':
        final walletCubit = WalletCubit(walletRepository);
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: walletCubit,
            child: WalletPage(),
          ),
        );

      case '/addWallet':
        final walletCubit = WalletCubit(walletRepository);
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: walletCubit,
            child: AddService(),
          ),
        );
    }
    return null;
  }
}
