import 'package:flutter/material.dart';
import 'package:phone_store/Classes/service_class.dart';
import 'package:phone_store/Classes/wallet_class.dart';
import 'package:phone_store/Data/data_service_layer.dart';
import 'package:phone_store/Data/data_wallet_layer.dart';
import 'package:phone_store/pages/wallet_page.dart';
import 'package:phone_store/structure/button_builder.dart';
import 'package:phone_store/structure/input_box.dart';

Widget serviceBuilder(BuildContext context) {
  TextEditingController numberController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController costController = TextEditingController();
  Future<List<WalletData>> wallet = DataWalletLayer.getAllWallet();
  List<String> phoneNumbers = [];

  Future<void> getPhoneNumbers() async {
    List<WalletData> walletDataList = await wallet;
    for (var walletData in walletDataList) {
      phoneNumbers.add(walletData.phoneNumber);
    }
  }

  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InputBox(
                  fieldName: "نوع الخدمة",
                  controller: typeController,
                  drop: true,
                  items: ["سحب", " إيداع"],
                ),
                // Add drop-down list for phone numbers
                FutureBuilder(
                  future: getPhoneNumbers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Error loading phone numbers");
                    } else {
                      return InputBox(
                        fieldName: "رقم المحفظة",
                        controller: numberController,
                        drop: true,
                        items: phoneNumbers,
                      );
                    }
                  },
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InputBox(
                  fieldName: "التكلفه",
                  controller: costController,
                ),
                InputBox(
                  fieldName: " المبلغ المحول",
                  controller: amountController,
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            ButtonBuilder(
              buttonName: "سحب/إيداع",
              onPressed: () async {
                String type = typeController.text.trim();
                String quantityText = amountController.text.trim();

                if (type.isEmpty || quantityText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("الرجاء إدخال جميع الحقول بشكل صحيح"),
                    ),
                  );
                  return;
                }

                int? quantity = int.tryParse(quantityText);
                if (quantity == null || quantity <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("الرجاء إدخال المبلغ المطلوب"),
                    ),
                  );
                  return;
                }

                try {
                  String phone = numberController.text.trim();

                  if (!phoneNumbers.contains(phone)) {
                    print("wallet not found");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("رقم المحفظة غير موجود"),
                      ),
                    );
                    return;
                  }

                  ServiceRecord serviceRecord = ServiceRecord(
                    cost: double.tryParse(costController.text) ?? 0.0,
                    money: double.tryParse(amountController.text) ?? 0.0,
                    phoneNumber: phone,
                    serviceType: typeController.text,
                    walletId: numberController.text,
                  );

                  DataServiceLayer.addService(serviceRecord, context);
                  DataWalletLayer.updateWallet(numberController.text,
                      serviceRecord.money, serviceRecord.serviceType, context);

                  typeController.clear();
                  numberController.clear();
                  amountController.clear();
                  costController.clear();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("خطأ: ${e.toString()}"),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => WalletPage()));
              },
              child: const Icon(Icons.wallet),
            ),
          ),
        ),
      ],
    ),
  );
}
