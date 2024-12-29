import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:phone_store/Classes/sales_class.dart';
import 'package:phone_store/Classes/store_item_class.dart';
import 'package:phone_store/Data/data_inventory_layer.dart';
import 'package:phone_store/Statemangement/Cubit/Sales_Cubit/sales_state.dart';

class SalesCubit extends Cubit<SalesState> {
  SalesCubit() : super(SalesInitial());

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final String salesCollectionName = "dailySales";

  List<SaleRecord> items = [];

  Future<void> saveSaleRecord(SaleRecord sale, BuildContext context) async {
    try {
      emit(SalesLoading());
      print(sale.itemName);
      StoreItem? storeItem =
          await FirebaseDatabase.searchStoreByName(sale.itemName);

      if (storeItem == null) {
        print("Product '${sale.itemName}' not found in inventory.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product not found in inventory.")),
        );
        emit(SalesFailure("Product not found in inventory."));
        return;
      }

      if (storeItem.quantity < sale.quantitySold) {
        Dialogs.materialDialog(
          dialogWidth: 300,
          color: Colors.white,
          msg:
              "There is not enough quantity, available quantity is '${storeItem.quantity}'",
          title: 'Error Quantity',
          lottieBuilder: LottieBuilder.asset(
            'images/error.json',
            fit: BoxFit.contain,
          ),
          context: context,
          actions: [
            IconsButton(
              padding: EdgeInsets.all(20),
              onPressed: () {
                Navigator.pop(context);
              },
              text: 'OK',
              iconData: Icons.done,
              color: Colors.red,
              textStyle: const TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ],
        );
        print("Insufficient quantity available for '${sale.itemName}'.");
        emit(SalesFailure(
            "Insufficient quantity available for '${sale.itemName}'"));
        return;
      }

      DocumentReference docRef =
          await db.collection(salesCollectionName).add(sale.toJson());
      String docId = docRef.id;
      print("Sale record saved successfully with ID: $docId");

      await FirebaseDatabase.UpdateQuantityProduct(
          sale.quantitySold, sale.itemName, false);

      await docRef.update({'docId': docId});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم تسجيل البيع بنجاح")),
      );
      emit(SalesSuccess());
    } catch (e) {
      print("Error processing sale record: $e");
      emit(SalesFailure("Error processing sale record: $e"));
      rethrow;
    }
  }

  Future<List<SaleRecord>> getTodaySales() async {
    try {
      emit(SalesLoading());
      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);
      DateTime endOfDay =
          startOfDay.add(Duration(days: 1)).subtract(Duration(milliseconds: 1));

      QuerySnapshot querySnapshot = await db
          .collection(salesCollectionName)
          .where('dateOfSale',
              isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('dateOfSale', isLessThanOrEqualTo: endOfDay.toIso8601String())
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No sales records found for today.");
      } else {
        print("${querySnapshot.docs.length} sales records retrieved.");
      }

      List<SaleRecord> sales = querySnapshot.docs.map((doc) {
        return SaleRecord.fromJson(
          doc.data() as Map<String, dynamic>,
          docId: doc.id,
        );
      }).toList();

      emit(SalesFetched(sales));
      return sales;
    } catch (e) {
      print("Error retrieving today's sales records: $e");
      rethrow;
    }
  }

  Future<List<SaleRecord>> getSalesByDate(List<DateTime?> dates) async {
    List<SaleRecord> allSales = [];
    try {
      emit(SalesLoading());
      for (DateTime? date in dates) {
        DateTime startOfDay = DateTime(date!.year, date.month, date.day);
        DateTime endOfDay = startOfDay
            .add(Duration(days: 1))
            .subtract(Duration(milliseconds: 1));

        QuerySnapshot querySnapshot = await db
            .collection(salesCollectionName)
            .where('dateOfSale',
                isGreaterThanOrEqualTo: startOfDay.toIso8601String())
            .where('dateOfSale',
                isLessThanOrEqualTo: endOfDay.toIso8601String())
            .get();

        if (querySnapshot.docs.isEmpty) {
          print("No sales records found for today.");
        } else {
          print("${querySnapshot.docs.length} sales records retrieved.");
        }

        allSales.addAll(querySnapshot.docs.map((doc) {
          return SaleRecord.fromJson(
            doc.data() as Map<String, dynamic>,
            docId: doc.id, // Pass the document ID
          );
        }).toList());
      }
      emit(SalesFetched(allSales));
      return allSales;
    } catch (e) {
      print("Error retrieving today's sales records: $e");
      emit(SalesFailure("Error retrieving today's sales records: $e"));
      rethrow;
    }
  }

  Future<List<SaleRecord>> getSalesByOneDate(DateTime? date) async {
    List<SaleRecord> allSales = [];
    try {
      emit(SalesLoading());
      DateTime startOfDay = DateTime(date!.year, date.month, date.day);
      DateTime endOfDay =
          startOfDay.add(Duration(days: 1)).subtract(Duration(milliseconds: 1));

      QuerySnapshot querySnapshot = await db
          .collection(salesCollectionName)
          .where('dateOfSale',
              isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('dateOfSale', isLessThanOrEqualTo: endOfDay.toIso8601String())
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No sales records found for today.");
      } else {
        print("${querySnapshot.docs.length} sales records retrieved.");
      }

      allSales.addAll(querySnapshot.docs.map((doc) {
        return SaleRecord.fromJson(
          doc.data() as Map<String, dynamic>,
          docId: doc.id, // Pass the document ID
        );
      }).toList());
      emit(SalesFetched(allSales));
      return allSales;
    } catch (e) {
      print("Error retrieving today's sales records: $e");
      emit(SalesFailure("Error retrieving today's sales records: $e"));
      rethrow;
    }
  }

  Future<void> returnSaleRecord(String saleId, BuildContext context) async {
    try {
      emit(SalesLoading());
      DocumentSnapshot saleSnapshot =
          await db.collection(salesCollectionName).doc(saleId).get();

      if (!saleSnapshot.exists) {
        print("Sale record with ID '$saleId' does not exist.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Document not found"),
          ),
        );
        return;
      }

      SaleRecord sale = SaleRecord.fromJson(
        saleSnapshot.data() as Map<String, dynamic>,
        docId: saleSnapshot.id,
      );

      await db.collection(salesCollectionName).doc(saleId).delete();

      await FirebaseDatabase.UpdateQuantityProduct(
          sale.quantitySold, sale.itemName, true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم حذف السجل بنجاح"),
        ),
      );
      emit(SalesDeleted(saleId));
      print(
          "Sale record with ID '$saleId' deleted successfully and inventory updated.");
    } catch (e) {
      print("Error deleting sale record: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("فشل حذف السجل."),
        ),
      );
      emit(SalesFailure("Error deleting sale record: $e"));
      rethrow;
    }
  }

  Future<void> updateSaleRecord(
      SaleRecord oldSale, SaleRecord updatedSale, BuildContext context) async {
    emit(SalesLoading());
    var newQuantity = oldSale.quantitySold;

    if (oldSale.itemName != updatedSale.itemName) {
      await returnSaleRecord(oldSale.docId!, context);
      await saveSaleRecord(updatedSale, context);
      return;
    }
    if (updatedSale.quantitySold != oldSale.quantitySold) {
      var diff = (updatedSale.quantitySold - oldSale.quantitySold).abs();
      newQuantity += (updatedSale.quantitySold - oldSale.quantitySold);
      bool isRestock = updatedSale.quantitySold < oldSale.quantitySold;
      await FirebaseDatabase.UpdateQuantityProduct(
          diff, oldSale.itemName, isRestock);
    }

    await db.collection(salesCollectionName).doc(oldSale.docId).update({
      'quantitySold': newQuantity,
      'salePrice': updatedSale.salePrice,
    });
    print(
        "Sale record with ID '$oldSale.id' updated successfully and inventory updated.");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("تم تعديل البيانات  بنجاح")),
    );
    emit(SalesUpdated(updatedSale));
    return;
  }

  Future<void> fetchTodaySales() async {
    try {
      emit(SalesLoading());
      final itemsFetched = await getTodaySales();
      items = itemsFetched;
      emit(SalesFetched(itemsFetched));
    } catch (e) {
      print('Error fetching items: $e');
      emit(SalesFailure('Error fetching items: $e'));
    }
  }

  Future<void> fetchSalesForDates(List<DateTime?> dates) async {
    try {
      emit(SalesLoading());

      final itemsFetched = await getSalesByDate(dates);
      items = itemsFetched;
      emit(SalesFetched(itemsFetched));
    } catch (e) {
      print('Error fetching sales for selected dates: $e');
      emit(SalesFailure('Error fetching sales for selected dates: $e'));
    }
  }
}
