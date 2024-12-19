import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phone_store/Classes/wallet_class.dart';

class DataWalletLayer {
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static String collectionName = "wallet";

  static Future<void> addWallet(WalletData wallet) async {
    DocumentReference docRef =
        await firebaseFirestore.collection(collectionName).add(wallet.tojson());

    String docId = docRef.id;
    docRef.update({"docId": docId});
  }

  static Future<List<WalletData>> getAllWallet() async {
    List<WalletData> walletList = [];

    QuerySnapshot snapshot =
        await firebaseFirestore.collection(collectionName).get();
    walletList = snapshot.docs.map((doc) {
      return WalletData.fromjson(
        doc.data() as Map<String, dynamic>,
        docId: doc.id,
      );
    }).toList();

    return walletList;
  }

  static Future<WalletData?> getWalletById(String id) async {
    try {
      print("Querying for Wallet with ID: $id");

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
      print("Found Wallet: ${doc.data()}");

      return WalletData.fromjson(
        doc.data() as Map<String, dynamic>,
        docId: doc.id,
      );
    } catch (e) {
      print("Error in getWalletById: $e");
      return null;
    }
  }

  static Future<String?> getWalletDocId(String id) async {
    try {
      WalletData? wallet = await getWalletById(id);
      print("doc id is : ${wallet!.docId}");
      return wallet.docId;
    } catch (e) {
      print("Error in getWalletById: $e");
      return null;
    }
  }

  static Future<void> updateWallet(
      String id, double amount, String type, BuildContext context) async {
    try {
      WalletData? wallet = await getWalletById(id);
      print("doc id is : ${wallet!.docId}");

      double currentAmount = wallet.walletAmount ?? 0;
      double currentLimit = wallet.walletLimit ?? 0;

      if (type == "سحب") {
        if (currentAmount >= amount) {
          wallet.walletAmount = currentAmount + amount;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("balance not enough")),
          );
          print("Insufficient balance for withdrawal.");
          return;
        }
      } else {
        // Deposit case
        wallet.walletAmount = currentAmount - amount;
        wallet.walletLimit = currentLimit - amount;
      }

      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(wallet.docId)
          .set(wallet.tojson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaction successful")),
      );
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
}
