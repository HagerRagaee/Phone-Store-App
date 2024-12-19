import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
