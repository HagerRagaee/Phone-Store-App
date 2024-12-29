import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phone_store/Classes/wallet_class.dart';
import 'package:phone_store/Data/data_wallet_layer.dart';
import 'package:phone_store/structure/button_builder.dart';
import 'package:phone_store/structure/input_box.dart';

class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  TextEditingController typeController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController balanceController = TextEditingController();

  List phoneNumbers = [];

  String docId = "s1hQ7Gv6U5UrhI6JdG5O"; // Keep the docId for the walletCounter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Add Wallet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 98, 182, 250),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InputBox(
                fieldName: "رصيد المحفظه",
                controller: balanceController,
              ),
              InputBox(
                fieldName: "رقم المحفظه",
                controller: numberController,
              ),
              InputBox(
                fieldName: "نوع المحفظه",
                controller: typeController,
                drop: true,
                items: ["فودافون ", "اتصالات", "we"],
              ),
            ],
          ),
          SizedBox(height: 40),
          ButtonBuilder(
            buttonName: "أضف المحفظه",
            onPressed: () async {
              String type = typeController.text;
              String phoneNumber = numberController.text;
              double? balance = double.tryParse(balanceController.text);

              if (type.isEmpty || phoneNumber.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("الرجاء إدخال جميع الحقول بشكل صحيح")),
                );
                return;
              }

              // Validate phone number based on wallet type
              if (type == "فودافون" && !phoneNumber.startsWith("010")) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("رقم المحفظه يجب أن يبدأ بـ 010")),
                );
                return;
              } else if (type == "اتصالات" && !phoneNumber.startsWith("011")) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("رقم المحفظه يجب أن يبدأ بـ 011")),
                );
                return;
              } else if (type == "we" && !phoneNumber.startsWith("015")) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("رقم المحفظه يجب أن يبدأ بـ 015")),
                );
                return;
              }

              // Validate phone number length
              if (phoneNumber.length != 11) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("رقم المحفظه يجب أن يتكون من 11 رقمًا")),
                );
                return;
              }

              try {
                // Fetch current counter value
                DocumentSnapshot counterDoc = await FirebaseFirestore.instance
                    .collection("walletCounter")
                    .doc(docId)
                    .get();

                if (counterDoc.exists) {
                  int currentCounter = counterDoc['counter'] ?? 0;

                  // Create a new WalletData object
                  WalletData walletData = WalletData(
                      phoneNumber: phoneNumber,
                      walletId: '$currentCounter',
                      walletAmount: balance // Use a generated wallet ID
                      );

                  // Add the wallet data
                  await DataWalletLayer.addWallet(walletData);

                  // Update the wallet counter in Firestore
                  await FirebaseFirestore.instance
                      .collection("walletCounter")
                      .doc(docId)
                      .update({'counter': currentCounter + 1});

                  typeController.clear();
                  numberController.clear();
                  balanceController.clear();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("تم إضافة/تعديل المحفظه بنجاح")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("خطأ في استرجاع العداد")),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("حدث خطأ: ${e.toString()}")),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
