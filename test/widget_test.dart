// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_store/app_route.dart';
import 'package:phone_store/data/firebase_data/data_balance_layer.dart';
import 'package:phone_store/data/firebase_data/data_sales_layer.dart';
import 'package:phone_store/data/firebase_data/data_service_layer.dart';
import 'package:phone_store/data/firebase_data/data_wallet_layer.dart';
import 'package:phone_store/data/repository/balance_repository.dart';
import 'package:phone_store/data/repository/sales_repository.dart';
import 'package:phone_store/data/repository/service_repository.dart';
import 'package:phone_store/data/repository/wallet_repository.dart';

import 'package:phone_store/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(PhoneApp(
      route: AppRoute(),
      repository: SalesRepository(FirebaseOperations as FirebaseOperations),
      serviceRepository:
          ServiceRepository(DataServiceLayer as DataServiceLayer),
      walletRepository: WalletRepository(DataWalletLayer as DataWalletLayer),
      balanceRepository:
          BalanceRepository(DataBalanceLayer as DataBalanceLayer),
    ));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
