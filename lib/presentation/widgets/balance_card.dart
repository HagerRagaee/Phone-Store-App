// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:phone_store/bussines_logic/Cubit/Balance_Cubit/balance_cubit.dart';
import 'package:phone_store/data/models/balance_model.dart';
import 'package:phone_store/presentation/widgets/balance_builder.dart';

class BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: Column(
                children: [
                  _buildHeaderRow(context),
                  for (var balance
                      in BlocProvider.of<BalanceCubit>(context).balanceRecordes)
                    _buildDataRow(context, balance),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Row(
        children: [
          Expanded(child: _buildTableCell('الربح', isHeader: true)),
          Expanded(child: _buildTableCell("التكلفه", isHeader: true)),
          Expanded(child: _buildTableCell("السعر", isHeader: true)),
          Expanded(child: _buildTableCell('بيان', isHeader: true)),
        ],
      ),
    );
  }

  Widget _buildDataRow(BuildContext context, BalanceModel balance) {
    return InkWell(
      onTap: () {
        Dialogs.materialDialog(
          dialogWidth: 300,
          color: Colors.white,
          msg: 'Want Delete or Update?',
          title: 'Delete or Update',
          lottieBuilder: LottieBuilder.asset(
            'images/return.json',
            fit: BoxFit.contain,
          ),
          context: context,
          actions: [
            IconsButton(
              padding: EdgeInsets.all(20),
              onPressed: () async {
                Navigator.pop(context);
                bool removed = await BlocProvider.of<BalanceCubit>(context)
                    .deleteBalanceRecord(balance.docId!, context);
                if (removed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("تم حذف السجل بنجاح"),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("خطأ: فشل حذف عمليه الحذف"),
                    ),
                  );
                }
              },
              text: 'Delete',
              iconData: Icons.close,
              color: Colors.red,
              textStyle: const TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
            IconsButton(
              padding: EdgeInsets.all(20),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BalanceBuilder(
                      balanceModel: balance,
                    ),
                  ),
                );
              },
              text: 'Update',
              iconData: Icons.done,
              color: Colors.blue,
              textStyle: const TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ],
        );
      },
      child: Row(
        children: [
          Expanded(child: _buildTableCell((balance.profit).toString())),
          Expanded(child: _buildTableCell((balance.cost).toString())),
          Expanded(child: _buildTableCell((balance.price).toString())),
          Expanded(child: _buildTableCell(balance.type)),
        ],
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isHeader ? 16 : 14,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.black87 : Colors.black54,
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
      ),
    );
  }
}
