// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phone_store/data/models/balance_model.dart';

class DataBalanceLayer {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final String collectionName = "balance";

  Future<void> addBalance(
      BalanceModel balanceModel, BuildContext context) async {
    DocumentReference reference =
        await db.collection(collectionName).add(balanceModel.toJson());

    String docId = reference.id;
    reference.update({"docId": docId});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("تم الشحن بنجاح"),
      ),
    );
  }

  Future<List<BalanceModel>> getTodayBalances() async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay =
        startOfDay.add(Duration(days: 1)).subtract(Duration(milliseconds: 1));
    QuerySnapshot querySnapshot = await db
        .collection(collectionName)
        .where('dateOfSale',
            isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('dateOfSale', isLessThanOrEqualTo: endOfDay.toIso8601String())
        .get();

    return querySnapshot.docs.map((doc) {
      return BalanceModel.fromJson(
        doc.data() as Map<String, dynamic>,
        docId: doc.id,
      );
    }).toList();
  }

  Future<List<BalanceModel>> getBalanceByDate(List<DateTime?> dates) async {
    List<BalanceModel> allbalances = [];
    try {
      for (DateTime? date in dates) {
        DateTime startOfDay = DateTime(date!.year, date.month, date.day);
        DateTime endOfDay = startOfDay
            .add(Duration(days: 1))
            .subtract(Duration(milliseconds: 1));

        QuerySnapshot querySnapshot = await db
            .collection(collectionName)
            .where('dateOfSale',
                isGreaterThanOrEqualTo: startOfDay.toIso8601String())
            .where('dateOfSale',
                isLessThanOrEqualTo: endOfDay.toIso8601String())
            .get();

        allbalances.addAll(querySnapshot.docs.map((doc) {
          return BalanceModel.fromJson(
            doc.data() as Map<String, dynamic>,
            docId: doc.id, // Pass the document ID
          );
        }).toList());
      }

      return allbalances;
    } catch (e) {
      print("Error retrieving today's balances records: $e");
      rethrow;
    }
  }

  Future<BalanceModel?> getBalanceById(String id) async {
    try {
      QuerySnapshot snapshot = await db
          .collection(collectionName)
          .where('docId', isEqualTo: id)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        print("Wallet not found.");
        return null;
      }

      var doc = snapshot.docs.first;
      return BalanceModel.fromJson(
        doc.data() as Map<String, dynamic>,
        docId: doc.id,
      );
    } catch (e) {
      print("Error in getWalletById: $e");
      return null;
    }
  }

  Future<bool> deleteBalanceRecord(
      String balanceId, BuildContext context) async {
    try {
      DocumentSnapshot balanceRecord =
          await db.collection(collectionName).doc(balanceId).get();

      if (!balanceRecord.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Document not found"),
          ),
        );
        return false;
      }

      await db.collection(collectionName).doc(balanceId).delete();

      return true;
    } catch (e) {
      print("Error deleting balance record: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("فشل حذف السجل."),
        ),
      );
      rethrow;
    }
  }
}
