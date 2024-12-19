class SaleRecord {
  final String id;
  final String itemName;
  final int quantitySold;
  final double salePrice;
  final DateTime dateOfSale;
  String? docId; // Document ID from Firestore, nullable

  SaleRecord({
    required this.id,
    required this.itemName,
    required this.quantitySold,
    required this.salePrice,
    required this.dateOfSale,
    this.docId, // Optional document ID
  });

  // Convert a SaleRecord to a JSON-like map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemName': itemName,
      'quantitySold': quantitySold,
      'salePrice': salePrice,
      'dateOfSale': dateOfSale.toIso8601String(),
    };
  }

  // Create a SaleRecord from Firestore data, including the docId
  factory SaleRecord.fromJson(Map<String, dynamic> json, {String? docId}) {
    return SaleRecord(
      id: json['id'],
      itemName: json['itemName'],
      quantitySold: json['quantitySold'],
      salePrice: json['salePrice'],
      dateOfSale: DateTime.parse(json['dateOfSale']),
      docId: docId, // Assign the Firestore document ID
    );
  }
}
