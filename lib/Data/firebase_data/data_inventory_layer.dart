// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phone_store/data/models/store_item_class.dart';

class FirebaseDatabase {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final String collectionName = "storeItems";

  Future<void> saveOrUpdateStore(StoreItem item) async {
    try {
      DocumentSnapshot docSnapshot =
          await db.collection(collectionName).doc(item.itemName).get();

      if (docSnapshot.exists) {
        await db
            .collection(collectionName)
            .doc(item.itemName)
            .set(item.toJson());
      } else {
        await db
            .collection(collectionName)
            .doc(item.itemName)
            .set(item.toJson());
      }
      print('Item saved or updated successfully!');
    } catch (e) {
      print('Error saving or updating item: $e');
      rethrow;
    }
  }

  Future<List<StoreItem>> getAllStores() async {
    try {
      QuerySnapshot querySnapshot = await db.collection(collectionName).get();
      List<StoreItem> storeList = [];

      for (var doc in querySnapshot.docs) {
        storeList.add(StoreItem.fromJson(doc.data() as Map<String, dynamic>));
      }

      return storeList;
    } catch (e) {
      print('Error retrieving store items: $e');
      rethrow;
    }
  }

  Future<StoreItem?> searchStoreByName(String itemName) async {
    try {
      DocumentSnapshot docSnapshot =
          await db.collection(collectionName).doc(itemName).get();

      if (docSnapshot.exists) {
        return StoreItem.fromJson(docSnapshot.data() as Map<String, dynamic>);
      } else {
        print("Item with name '$itemName' not found.");
        return null;
      }
    } catch (e) {
      print('Error searching for item: $e');
      rethrow;
    }
  }

  Future<double?> getCosteByName(String itemName) async {
    try {
      if (searchStoreByName != null) {
        return searchStoreByName(itemName).then((storeItem) {
          return storeItem?.itemCost;
        });
      }
    } catch (e) {
      print('Error getting price: $e');
      rethrow;
    }
    return null;
  }

  Future<void> UpdateQuantityProduct(
      int quantity, String productName, bool back) async {
    try {
      StoreItem? storeItem = await searchStoreByName(productName);
      if (storeItem != null) {
        storeItem.quantity = back
            ? (storeItem.quantity + quantity).clamp(0, double.infinity).toInt()
            : (storeItem.quantity - quantity).clamp(0, double.infinity).toInt();
        await saveOrUpdateStore(storeItem);
        print("Product quantity updated successfully!");
      } else {
        print("Product '$productName' not found in inventory.");
      }
    } catch (e) {
      print("Error updating product quantity: $e");
      rethrow;
    }
  }

  Future<void> deleteItem(String itemName) async {
    try {
      await db.collection(collectionName).doc(itemName).delete();
      print("Wallet with docId $itemName has been successfully deleted.");
    } catch (e) {
      print("Error deleting wallet: $e");
    }
  }
}
