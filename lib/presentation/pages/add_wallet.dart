import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_store/bussines_logic/Cubit/Wallet_Cubit/wallet_cubit.dart';
import 'package:phone_store/data/models/wallet_class.dart';
import '../widgets/button_builder.dart';
import '../widgets/input_box.dart';

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
                String type = typeController.text.trim();
                String phoneNumber = numberController.text.trim();
                String balanceText = balanceController.text.trim();
                double? balance = double.tryParse(balanceText);

                if (type.isEmpty ||
                    phoneNumber.isEmpty ||
                    balanceText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("الرجاء إدخال جميع الحقول بشكل صحيح")),
                  );
                  return;
                }
                phoneNumber = phoneNumber.replaceAll(RegExp(r'\s+'), '');
                if (type == "فودافون" && !phoneNumber.startsWith("010")) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("رقم المحفظه يجب أن يبدأ بـ 010")),
                  );
                  return;
                } else if (type == "اتصالات" &&
                    !phoneNumber.startsWith("011")) {
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

                if (phoneNumber.length != 11 ||
                    !RegExp(r'^\d+$').hasMatch(phoneNumber)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("رقم المحفظه يجب أن يتكون من 11 رقمًا")),
                  );
                  return;
                }

                try {
                  bool walletExists =
                      await BlocProvider.of<WalletCubit>(context)
                          .walletExists(phoneNumber);

                  if (walletExists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("المحفظه موجوده مسبقًا")),
                    );
                    return;
                  }
                  int counter = BlocProvider.of<WalletCubit>(context)
                      .getWalletCounter(docId);

                  if (counter >= 0) {
                    WalletData walletData = WalletData(
                      phoneNumber: phoneNumber,
                      walletId: '$counter',
                      walletAmount: balance,
                    );

                    BlocProvider.of<WalletCubit>(context).addWallet(walletData);
                    BlocProvider.of<WalletCubit>(context)
                        .updateWalletCounter(docId, counter);

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
              })
        ],
      ),
    );
  }
}
