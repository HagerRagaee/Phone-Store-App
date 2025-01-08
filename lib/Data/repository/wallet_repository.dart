import 'package:flutter/material.dart';
import 'package:phone_store/data/firebase_data/data_wallet_layer.dart';
import 'package:phone_store/data/models/wallet_class.dart';

class WalletRepository {
  final DataWalletLayer dataWalletLayer;
  WalletRepository(this.dataWalletLayer);

  Future<void> addWallet(WalletData wallet) async {
    try {
      await dataWalletLayer.addWallet(wallet);
    } catch (e) {
      print("Error adding wallet ${e}");
    }
  }

  Future<List<WalletData>> getAllWallet() async {
    try {
      return await dataWalletLayer.getAllWallet();
    } catch (e) {
      print('Error fetching Wallets: $e');
      return [];
    }
  }

  Future<WalletData?> getWalletById(String id) async {
    try {
      return await dataWalletLayer.getWalletById(id);
    } catch (e) {
      print('Error fetching Wallet by id: $e');
      return null;
    }
  }

  Future<bool> updateWallet(String id, double amount, double cost, String type,
      BuildContext context) async {
    try {
      return await dataWalletLayer.updateWallet(
          id, amount, cost, type, context);
    } catch (e) {
      print('Error updating Wallet: $e');
      return false;
    }
  }

  Future<void> returnWalletAmount(String id, double amount, double cost,
      String type, BuildContext context) async {
    try {
      return await dataWalletLayer.returnWalletAmount(
          id, amount, cost, type, context);
    } catch (e) {
      print('Error returning Wallet amount: $e');
    }
  }

  Future<void> deleteWallet(String docId) async {
    try {
      await dataWalletLayer.deleteWallet(docId);
    } catch (e) {
      print('Error deleting Wallet: $e');
    }
  }

  Future<void> resetWalletLimitsIfNeeded() async {
    try {
      await dataWalletLayer.resetWalletLimitsIfNeeded();
    } catch (e) {
      print('Error resetting Wallet limits: $e');
    }
  }

  // Future<List<String>> getPhoneNumbers(BuildContext context) async {
  //   try {
  //     return await dataWalletLayer.getPhoneNumbers(context);
  //   } catch (e) {
  //     print('Error fetching Wallets: $e');
  //     return [];
  //   }
  // }
}
