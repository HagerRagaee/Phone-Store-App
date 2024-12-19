class WalletData {
  String? docId;
  String? walletId;
  final String phoneNumber;
  double? walletAmount;
  double? walletLimit = 200000.0;

  WalletData({
    this.docId,
    required this.phoneNumber,
    this.walletAmount,
    this.walletId,
    this.walletLimit,
  });

  Map<String, dynamic> tojson() {
    return {
      "phoneNumber": phoneNumber,
      "walletAmount": walletAmount,
      "walletId": walletId,
      "walletLimit": walletLimit ?? 200000.0,
    };
  }

  static WalletData fromjson(Map<String, dynamic> json, {String? docId}) {
    return WalletData(
      walletId: json["walletId"],
      docId: docId,
      phoneNumber: json['phoneNumber'],
      walletAmount: json['walletAmount'],
      walletLimit: json['walletLimit'],
    );
  }
}
