import 'package:cloud_firestore/cloud_firestore.dart';

class WalletData {
  String? docId;
  String? walletId;
  final String phoneNumber;
  double? walletAmount;
  double? walletLimit;
  DateTime? lastResetDate;

  WalletData({
    this.docId,
    required this.phoneNumber,
    this.walletAmount,
    this.walletId,
    this.lastResetDate,
    this.walletLimit = 200000.0,
  });

  Map<String, dynamic> toJson() {
    return {
      "phoneNumber": phoneNumber,
      "walletAmount": walletAmount,
      "walletId": walletId,
      "walletLimit": walletLimit ?? 200000.0,
      "lastResetDate": lastResetDate?.toIso8601String(),
    };
  }

  static WalletData fromJson(Map<String, dynamic> json, {String? docId}) {
    return WalletData(
      walletId: json["walletId"] as String?,
      docId: docId,
      phoneNumber: json['phoneNumber'] as String,
      walletAmount: json['walletAmount'] is String
          ? double.tryParse(json['walletAmount'])
          : (json['walletAmount'] as num?)?.toDouble(),
      walletLimit: json['walletLimit'] is String
          ? double.tryParse(json['walletLimit'])
          : (json['walletLimit'] as num?)?.toDouble(),
      lastResetDate: json['lastResetDate'] is Timestamp
          ? (json['lastResetDate'] as Timestamp).toDate()
          : json['lastResetDate'] != null
              ? DateTime.parse(json['lastResetDate'])
              : null,
    );
  }
}
