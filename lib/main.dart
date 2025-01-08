import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_store/Functions/tabs_navigator.dart';
import 'package:phone_store/app_route.dart';
import 'package:phone_store/bussines_logic/Cubit/Balance_Cubit/balance_cubit.dart';
import 'package:phone_store/bussines_logic/Cubit/Wallet_Cubit/wallet_cubit.dart';
import 'package:phone_store/data/firebase_data/data_balance_layer.dart';
import 'package:phone_store/data/firebase_data/data_sales_layer.dart';
import 'package:phone_store/data/firebase_data/data_service_layer.dart';
import 'package:phone_store/data/repository/balance_repository.dart';
import 'package:phone_store/data/repository/sales_repository.dart';
import 'package:phone_store/data/repository/service_repository.dart';
import 'package:phone_store/data/repository/wallet_repository.dart';
import 'data/firebase_data/data_wallet_layer.dart';
import 'bussines_logic/Cubit/Sales_Cubit/sales_cubit.dart';
import 'bussines_logic/Cubit/Service_Cubit/service_cubit.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyBISfchz_Oqja031y6HX3fLdZxlt7KZbKo',
      appId: '1:8491422775:android:bf76fee0d71231b04d9bb2',
      messagingSenderId: '',
      projectId: 'phone-store-f967b',
    ),
  );

  final DataWalletLayer dataWalletLayer = DataWalletLayer();
  final FirebaseOperations firebaseOperations = FirebaseOperations();
  final DataServiceLayer dataServiceLayer = DataServiceLayer();
  final DataBalanceLayer dataBalanceLayer = DataBalanceLayer();

  await dataWalletLayer.resetWalletLimitsIfNeeded();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProvStore(),
        ),
      ],
      child: PhoneApp(
        route: AppRoute(),
        repository: SalesRepository(firebaseOperations),
        serviceRepository: ServiceRepository(dataServiceLayer),
        walletRepository: WalletRepository(dataWalletLayer),
        balanceRepository: BalanceRepository(dataBalanceLayer),
      ),
    ),
  );
}

class PhoneApp extends StatelessWidget {
  const PhoneApp({
    super.key,
    required this.route,
    required this.repository,
    required this.serviceRepository,
    required this.walletRepository,
    required this.balanceRepository,
  });

  final AppRoute route;
  final SalesRepository repository;
  final ServiceRepository serviceRepository;
  final WalletRepository walletRepository;
  final BalanceRepository balanceRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ServiceCubit(serviceRepository)),
        BlocProvider(create: (_) => SalesCubit(repository)),
        BlocProvider(create: (_) => WalletCubit(walletRepository)),
        BlocProvider(create: (_) => BalanceCubit(balanceRepository)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: route.generateRoutes,
      ),
    );
  }
}
