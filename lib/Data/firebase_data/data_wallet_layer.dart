// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phone_store/data/models/wallet_class.dart';

class DataWalletLayer {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String collectionName = "wallet";

  Future<void> addWallet(WalletData wallet) async {
    DocumentReference docRef =
        await firebaseFirestore.collection(collectionName).add(wallet.toJson());

    String docId = docRef.id;
    docRef.update({"docId": docId});
  }

  Future<List<WalletData>> getAllWallet() async {
    QuerySnapshot snapshot =
        await firebaseFirestore.collection(collectionName).get();

    return snapshot.docs.map((doc) {
      return WalletData.fromJson(
        doc.data() as Map<String, dynamic>,
        docId: doc.id,
      );
    }).toList();
  }

  Future<List<WalletData>> searchWallet(String searchController) async {
    List<WalletData> searchResult = [];
    List<WalletData> result = await getAllWallet();
    for (WalletData data in result) {
      if (data.phoneNumber.startsWith(searchController)) {
        searchResult.add(data);
      }
    }
    return searchResult;
  }

  Future<WalletData?> getWalletById(String id) async {
    try {
      QuerySnapshot snapshot = await firebaseFirestore
          .collection(collectionName)
          .where('phoneNumber', isEqualTo: id)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        print("Wallet not found.");
        return null;
      }

      var doc = snapshot.docs.first;
      return WalletData.fromJson(
        doc.data() as Map<String, dynamic>,
        docId: doc.id,
      );
    } catch (e) {
      print("Error in getWalletById: $e");
      return null;
    }
  }

  Future<bool> updateWallet(String id, double amount, double cost, String type,
      BuildContext context) async {
    try {
      WalletData? wallet = await getWalletById(id);

      if (wallet == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("المحفظه غير موجودة")),
        );
        return false;
      }

      double currentAmount = wallet.walletAmount ?? 0;
      double currentLimit = wallet.walletLimit ?? 0;

      if (type == "سحب") {
        wallet.walletAmount = currentAmount + (amount);
      } else {
        if (wallet.walletAmount! < (cost) || wallet.walletLimit! < (cost)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("  الرصيد/الليميت غير كافي")),
          );
          return false;
        } else {
          wallet.walletAmount = currentAmount - (cost);
          wallet.walletLimit = currentLimit - (cost);
        }
      }

      await firebaseFirestore
          .collection(collectionName)
          .doc(wallet.docId)
          .set(wallet.toJson());

      return true;
    } catch (e) {
      print("Error updating wallet: $e");
      return false;
    }
  }

  Future<void> returnWalletAmount(String id, double amount, double cost,
      String type, BuildContext context) async {
    try {
      WalletData? wallet = await getWalletById(id);

      if (wallet == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("المحفظه غير موجودة")),
        );
        return;
      }

      double currentAmount = wallet.walletAmount ?? 0;
      double currentLimit = wallet.walletLimit ?? 0;

      if (type == "سحب") {
        wallet.walletAmount = currentAmount - (amount);
      } else {
        wallet.walletAmount = currentAmount + (cost);
        wallet.walletLimit = currentLimit + (cost);
        print("${type} + ${wallet.walletAmount}");
      }

      await firebaseFirestore
          .collection(collectionName)
          .doc(wallet.docId)
          .set(wallet.toJson());
    } catch (e) {
      print("Error updating wallet: $e");
    }
  }

  Future<void> deleteWallet(String docId) async {
    try {
      await firebaseFirestore.collection(collectionName).doc(docId).delete();
      print("Wallet with docId $docId has been successfully deleted.");
    } catch (e) {
      print("Error deleting wallet: $e");
    }
  }

  Future<void> resetWalletLimitsIfNeeded() async {
    try {
      List<WalletData> wallets = await getAllWallet();
      DateTime now = DateTime.now();

      for (WalletData wallet in wallets) {
        if (wallet.lastResetDate == null ||
            wallet.lastResetDate!.month != now.month ||
            wallet.lastResetDate!.year != now.year) {
          wallet.walletLimit = 200000.0;
          wallet.lastResetDate = now;

          await firebaseFirestore
              .collection(collectionName)
              .doc(wallet.docId)
              .set(wallet.toJson());
        }
      }

      print("Wallet limits reset if needed.");
    } catch (e) {
      print("Error resetting wallet limits: $e");
    }
  }

  Future<void> updateWalletCounter(String docId, int currentCounter) async {
    await FirebaseFirestore.instance
        .collection("walletCounter")
        .doc(docId)
        .update({'counter': currentCounter + 1});
  }

  Future<int> getWalletCounter(String docId) async {
    try {
      DocumentSnapshot counterDoc = await FirebaseFirestore.instance
          .collection("walletCounter")
          .doc(docId)
          .get();
      if (counterDoc.exists) {
        return counterDoc['counter'] ?? 0;
      }
      return -1;
    } catch (e) {
      print("Error getting wallet counter: $e");
      return -1;
    }
  }
}
