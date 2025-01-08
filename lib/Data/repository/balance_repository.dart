import 'package:flutter/material.dart';
import 'package:phone_store/data/firebase_data/data_balance_layer.dart';
import 'package:phone_store/data/models/balance_model.dart';

class BalanceRepository {
  late DataBalanceLayer dataBalanceLayer;
  BalanceRepository(this.dataBalanceLayer);

  Future<void> addBalance(
      BalanceModel balanceModel, BuildContext context) async {
    try {
      await dataBalanceLayer.addBalance(balanceModel, context);
    } catch (error) {
      print('Error adding balance: $error');
      return;
    }
  }

  Future<List<BalanceModel>> getTodayBalances() async {
    try {
      return await dataBalanceLayer.getTodayBalances();
    } catch (error) {
      print('Error fetching today balances: $error');
      return [];
    }
  }

  Future<List<BalanceModel>> getBalanceByDate(List<DateTime?> dates) async {
    try {
      return await dataBalanceLayer.getBalanceByDate(dates);
    } catch (error) {
      print('Error fetching balance by date: $error');
      return [];
    }
  }

  Future<BalanceModel?> getBalanceById(String id) async {
    try {
      return await dataBalanceLayer.getBalanceById(id);
    } catch (error) {
      print('Error fetching balance by ID: $error');
      return null;
    }
  }

  Future<bool> deleteBalanceRecord(
      String balanceId, BuildContext context) async {
    try {
      return await dataBalanceLayer.deleteBalanceRecord(balanceId, context);
    } catch (error) {
      print('Error deleting balance record: $error');
      return false;
    }
  }
}
