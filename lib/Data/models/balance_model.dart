class BalanceModel {
  final String type;
  final double price;
  final double cost;
  final double profit;
  final DateTime dateOfSale;
  String? docId;

  BalanceModel({
    required this.type,
    required this.price,
    required this.cost,
    required this.profit,
    required this.dateOfSale,
    this.docId,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'price': price,
      'cost': cost,
      'profit': profit,
      'dateOfSale': dateOfSale.toIso8601String(),
    };
  }

  factory BalanceModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    return BalanceModel(
      type: json['type'],
      price: json['price'],
      cost: json['cost'],
      profit: json['profit'],
      dateOfSale: DateTime.parse(json['dateOfSale']),
      docId: docId,
    );
  }
}
