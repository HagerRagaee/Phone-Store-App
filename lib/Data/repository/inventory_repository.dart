import 'package:phone_store/data/firebase_data/data_inventory_layer.dart';
import 'package:phone_store/data/models/store_item_class.dart';

class InventoryRepository {
  final FirebaseDatabase firebaseDatabase;
  InventoryRepository(this.firebaseDatabase);

  Future<void> saveOrUpdateStore(StoreItem item) async {
    try {
      await firebaseDatabase.saveOrUpdateStore(item);
    } catch (error) {
      print('Error saving item: $error');
    }
  }

  Future<List<StoreItem>> getAllStores() async {
    try {
      return await firebaseDatabase.getAllStores();
    } catch (error) {
      print('Error getting stores: $error');
      return [];
    }
  }

  Future<StoreItem?> searchStoreByName(String itemName) async {
    try {
      return await firebaseDatabase.searchStoreByName(itemName);
    } catch (e) {
      print(" not found: " + itemName);
    }
    return null;
  }

  Future<double?> getCosteByName(String itemName) async {
    try {
      return await firebaseDatabase.getCosteByName(itemName);
    } catch (e) {
      print("Error getting coste: " + itemName);
    }
    return null;
  }

  Future<void> UpdateQuantityProduct(
      int quantity, String productName, bool back) async {
    try {
      await firebaseDatabase.UpdateQuantityProduct(quantity, productName, back);
    } catch (e) {
      print("Error updating quantity: " + e.toString());
    }
  }

  Future<void> deleteItem(String itemName) async {
    try {
      await firebaseDatabase.deleteItem(itemName);
    } catch (e) {
      print("Error deleting item: " + e.toString());
    }
  }
}
