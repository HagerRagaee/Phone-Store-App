import 'package:flutter/material.dart';
import 'package:phone_store/data/firebase_data/data_sales_layer.dart';
import 'package:phone_store/data/models/sales_class.dart';

class SalesRepository {
  final FirebaseOperations firebaseOperations;

  SalesRepository(this.firebaseOperations);

  Future<void> saveSaleRecord(SaleRecord sale, BuildContext context) async {
    try {
      await firebaseOperations.saveSaleRecord(sale, context);
    } catch (e) {
      print('Error saving sale record: $e');
    }
  }

  Future<List<SaleRecord>> getTodaySales() async {
    try {
      return await firebaseOperations.getTodaySales();
    } catch (e) {
      print('Error fetching today sales: $e');
      return [];
    }
  }

  Future<List<SaleRecord>> getSalesByDate(List<DateTime?> dates) async {
    try {
      return await firebaseOperations.getSalesByDate(dates);
    } catch (e) {
      print('Error fetching sales by date: $e');
      return [];
    }
  }

  Future<List<SaleRecord>> getSalesByOneDate(DateTime? date) async {
    try {
      return await firebaseOperations.getSalesByOneDate(date);
    } catch (e) {
      print('Error fetching sales by one date: $e');
      return [];
    }
  }

  Future<void> returnSaleRecord(String saleId, BuildContext context) async {
    try {
      await firebaseOperations.returnSaleRecord(saleId, context);
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  Future<void> updateSaleRecord(
      SaleRecord oldSale, SaleRecord updatedSale, BuildContext context) async {
    try {
      await firebaseOperations.updateSaleRecord(oldSale, updatedSale, context);
    } catch (e) {
      print("Error: " + e.toString());
    }
  }
}
