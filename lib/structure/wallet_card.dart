import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:phone_store/Classes/wallet_class.dart';
import 'package:phone_store/Data/data_wallet_layer.dart';
import 'package:phone_store/pages/wallet_page.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class WalletCard extends StatefulWidget {
  WalletCard({super.key, required this.wallet});

  final WalletData wallet;

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  String getCarrierName(String phoneNumber) {
    if (phoneNumber.startsWith('010')) {
      return 'Vodafone';
    } else if (phoneNumber.startsWith('011')) {
      return 'Etisalat';
    } else {
      return 'WE';
    }
  }

  Widget getCarrierIcon(String phoneNumber) {
    if (phoneNumber.startsWith('010')) {
      return Image.asset("images/vodafone.png", width: 40, height: 40);
    } else if (phoneNumber.startsWith('011')) {
      return Image.asset("images/etisalat.png", width: 40, height: 40);
    } else {
      return Image.asset("images/we.png", width: 40, height: 40);
    }
  }

  Color getBalanceColor(double limit) {
    if (limit >= 15000) {
      return Colors.green; // High balance (blue)
    } else if (limit >= 10000) {
      return Colors.orange; // Medium balance (orange)
    } else {
      return Colors.red; // Low balance (red)
    }
  }

  @override
  Widget build(BuildContext context) {
    final balance = widget.wallet.walletAmount ?? 0.0;
    final limit = widget.wallet.walletLimit ?? 0.0;

    final balanceColor = getBalanceColor(limit);

    return GestureDetector(
      onTap: () {
        Dialogs.materialDialog(
          dialogWidth: 300,
          color: Colors.white,
          msg: 'Are you sure you want to delete ${widget.wallet.phoneNumber}?',
          title: 'Delete item',
          lottieBuilder: LottieBuilder.asset(
            'images/delete.json',
            fit: BoxFit.contain,
          ),
          context: context,
          actions: [
            IconsButton(
              padding: EdgeInsets.all(20),
              onPressed: () {
                DataWalletLayer.deleteWallet(widget.wallet.docId!);
                Navigator.pop(context);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => WalletPage()));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Deleted successfully")),
                );
              },
              text: 'Delete',
              iconData: Icons.done,
              color: Colors.red,
              textStyle: const TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
            IconsButton(
              padding: EdgeInsets.all(20),
              onPressed: () {
                Navigator.pop(context);
              },
              text: 'Cancel',
              iconData: Icons.close,
              color: Colors.blue,
              textStyle: const TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ],
        );
      },
      child: Card(
        color: const Color.fromARGB(255, 222, 138, 236),
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      getCarrierName(widget.wallet.phoneNumber),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    getCarrierIcon(widget.wallet.phoneNumber),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListTile(
                  title: Text(
                    '\$${balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Text(
                    '${((limit / 200000) * 100)}%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: StepProgressIndicator(
                  progressDirection: TextDirection.ltr,
                  totalSteps: 100,
                  currentStep: ((limit / 200000.0) * 100)
                      .toInt()
                      .clamp(0, 100), // Clamp the value between 0 and 100
                  size: 8,
                  padding: 0,
                  selectedColor: balanceColor,
                  unselectedColor: Colors.white,
                  roundedEdges: const Radius.circular(20),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                  color: Colors.white,
                ),
              ),
              ListTile(
                title: Text(
                  ' ${widget.wallet.phoneNumber}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                trailing: Text(
                  ' ${widget.wallet.walletLimit}',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
