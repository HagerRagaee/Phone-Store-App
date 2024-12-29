import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phone_store/Classes/wallet_class.dart';

class DataWalletLayer {
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static String collectionName = "wallet";

  static Future<void> addWallet(WalletData wallet) async {
    DocumentReference docRef =
        await firebaseFirestore.collection(collectionName).add(wallet.toJson());

    String docId = docRef.id;
    docRef.update({"docId": docId});
  }

  static Future<List<WalletData>> getAllWallet() async {
    QuerySnapshot snapshot =
        await firebaseFirestore.collection(collectionName).get();

    return snapshot.docs.map((doc) {
      return WalletData.fromJson(
        doc.data() as Map<String, dynamic>,
        docId: doc.id,
      );
    }).toList();
  }

  static Future<WalletData?> getWalletById(String id) async {
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

  static Future<void> updateWallet(String id, double amount, double cost,
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
        if (currentAmount >= amount) {
          wallet.walletAmount = currentAmount + (amount - cost);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("الرصيد غير كافي")),
          );
          return;
        }
      } else {
        wallet.walletAmount = currentAmount - (amount - cost);
        wallet.walletLimit = currentLimit - (amount - cost);
      }

      await firebaseFirestore
          .collection(collectionName)
          .doc(wallet.docId)
          .set(wallet.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("تمت عمليه $type بنجاح")),
      );
    } catch (e) {
      print("Error updating wallet: $e");
    }
  }

  static Future<void> returnWalletAmount(String id, double amount, double cost,
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
        wallet.walletAmount = currentAmount - (amount - cost);
      } else {
        wallet.walletAmount = currentAmount + (amount - cost);
        wallet.walletLimit = currentLimit + (amount - cost);
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

  // Method to delete a wallet by docId
  static Future<void> deleteWallet(String docId) async {
    try {
      await firebaseFirestore.collection(collectionName).doc(docId).delete();
      print("Wallet with docId $docId has been successfully deleted.");
    } catch (e) {
      print("Error deleting wallet: $e");
    }
  }

  static Future<void> resetWalletLimitsIfNeeded() async {
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
}
