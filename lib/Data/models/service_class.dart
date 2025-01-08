class ServiceRecord {
  final String walletId;
  String? docId;
  final String phoneNumber;
  final double money;
  final String serviceType;
  final double cost;
  DateTime? serviceDate;

  ServiceRecord({
    required this.serviceType,
    required this.walletId,
    required this.phoneNumber,
    required this.money,
    required this.cost,
    this.docId,
    this.serviceDate,
  }) {
    serviceDate = DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': walletId,
      'phoneNumber': phoneNumber,
      'money': money,
      'serviceType': serviceType,
      'cost': cost,
      'serviceDate': serviceDate!.toIso8601String(),
    };
  }

  factory ServiceRecord.fromJson(Map<String, dynamic> json, {String? docId}) {
    return ServiceRecord(
      walletId: json['id'],
      phoneNumber: json['phoneNumber'],
      money: json['money'],
      serviceType: json['serviceType'],
      cost: json['cost'],
      docId: docId,
      serviceDate: DateTime.parse(json['serviceDate']),
    );
  }
}
