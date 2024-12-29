import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_store/Data/data_wallet_layer.dart';
import 'package:phone_store/Statemangement/Cubit/Sales_Cubit/sales_cubit.dart';
import 'package:phone_store/Statemangement/Cubit/Service_Cubit/service_cubit.dart';
import 'package:phone_store/Statemangement/provider_store_class.dart';
import 'package:phone_store/pages/home_page.dart';
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
  await DataWalletLayer.resetWalletLimitsIfNeeded();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProvStore(),
        ),
      ],
      child: const MyApp(), // Move the child here.
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ServiceCubit()),
        BlocProvider(create: (_) => SalesCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
