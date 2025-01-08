// ignore_for_file: non_constant_identifier_names

class StoreItem {
  late String itemName;
  late double itemCost;
  late int quantity;

  StoreItem(this.itemName, this.itemCost, this.quantity);

  get ItemQuantity {
    return quantity;
  }

  void updateQuantity(int newQuantity) {
    quantity = newQuantity;
  }

  double calculateTotalCost() {
    return quantity * itemCost;
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'itemCost': itemCost,
      'quantity': quantity,
    };
  }

  static StoreItem fromJson(Map<String, dynamic> json) {
    return StoreItem(
      json['itemName'],
      json['itemCost'],
      json['quantity'],
    );
  }
}
