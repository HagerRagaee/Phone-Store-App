class SaleRecord {
  final String id;
  final String itemName;
  final int quantitySold;
  final double salePrice;
  final DateTime dateOfSale;
  String? docId;

  SaleRecord({
    required this.id,
    required this.itemName,
    required this.quantitySold,
    required this.salePrice,
    required this.dateOfSale,
    this.docId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemName': itemName,
      'quantitySold': quantitySold,
      'salePrice': salePrice,
      'dateOfSale': dateOfSale.toIso8601String(),
    };
  }

  factory SaleRecord.fromJson(Map<String, dynamic> json, {String? docId}) {
    return SaleRecord(
      id: json['id'],
      itemName: json['itemName'],
      quantitySold: json['quantitySold'],
      salePrice: json['salePrice'],
      dateOfSale: DateTime.parse(json['dateOfSale']),
      docId: docId,
    );
  }
}
