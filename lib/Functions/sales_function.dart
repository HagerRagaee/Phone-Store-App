import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_store/Statemangement/Cubit/Sales_Cubit/sales_cubit.dart';
import 'package:phone_store/Statemangement/Cubit/Service_Cubit/service_cubit.dart';

double calculateTotalSales(BuildContext context) {
  double totalSales = 0;
  for (var sale in BlocProvider.of<SalesCubit>(context).items) {
    totalSales += sale.salePrice;
  }
  for (var ser in BlocProvider.of<ServiceCubit>(context).services) {
    totalSales += ser.money;
  }
  return totalSales;
}

// Future<double> calculateTotalProfit(BuildContext context) async {
//   double totalProfit = 0;
//  for (var sale in BlocProvider.of<SalesCubit>(context).items) {
//     totalProfit += (sale.salePrice) - (sale.quantitySold * sale.c);
//   }
//   for (var ser in BlocProvider.of<ServiceCubit>(context).services) {
//     totalProfit += ser.cost;
//   }
//   return totalProfit;
// }
