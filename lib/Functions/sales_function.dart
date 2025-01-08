// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_store/bussines_logic/Cubit/Balance_Cubit/balance_cubit.dart';
import 'package:phone_store/data/firebase_data/data_inventory_layer.dart';
import '../bussines_logic/Cubit/Sales_Cubit/sales_cubit.dart';
import 'package:phone_store/bussines_logic/Cubit/Service_Cubit/service_cubit.dart';

double calculateTotalSales(BuildContext context) {
  double totalSales = 0;
  for (var sale in BlocProvider.of<SalesCubit>(context).sales) {
    totalSales += sale.salePrice;
  }
  for (var ser in BlocProvider.of<ServiceCubit>(context).services) {
    totalSales += ser.money;
  }
  for (var balance in BlocProvider.of<BalanceCubit>(context).balanceRecordes) {
    totalSales += balance.price;
  }
  return totalSales;
}

Future<double> calculateTotalProfit(BuildContext context) async {
  FirebaseDatabase firebaseDatabase = FirebaseDatabase();

  double totalProfit = 0;
  for (var sale in BlocProvider.of<SalesCubit>(context).sales) {
    final double cost =
        (await firebaseDatabase.getCosteByName(sale.itemName)) ?? 0.0;
    totalProfit += (sale.salePrice - (sale.quantitySold * cost));
  }
  for (var ser in BlocProvider.of<ServiceCubit>(context).services) {
    totalProfit += (ser.money - ser.cost);
  }
  for (var balance in BlocProvider.of<BalanceCubit>(context).balanceRecordes) {
    totalProfit += balance.profit;
  }
  return totalProfit;
}
