import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:phone_store/Classes/sales_class.dart';
import 'package:phone_store/Data/data_inventory_layer.dart';
import 'package:phone_store/Data/data_sales_layer.dart';
import 'package:phone_store/Functions/sales_function.dart';
import 'package:phone_store/structure/button_builder.dart';

class SalesCard extends StatelessWidget {
  final List<SaleRecord> items;

  SalesCard({required this.items});

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
                  for (var item in items) _buildDataRow(context, item),
                ],
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: ButtonBuilder(
                buttonName: "مبيعات اليوم",
                onPressed: () async {
                  double totalSales = calculateTotalSales(items);

                  Dialogs.materialDialog(
                    dialogWidth: 300,
                    color: Colors.white,
                    msg: 'Total Sales: ${totalSales.toStringAsFixed(2)}',
                    title: 'Daily Sales',
                    lottieBuilder: LottieBuilder.asset(
                      'images/profit2.json',
                      fit: BoxFit.contain,
                    ),
                    context: context,
                    actions: [
                      IconsButton(
                        padding: EdgeInsets.all(20),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: 'OK',
                        iconData: Icons.done,
                        color: Colors.blue,
                        textStyle: const TextStyle(color: Colors.white),
                        iconColor: Colors.white,
                      ),
                    ],
                  );
                },
              ),
            )
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
          Expanded(child: _buildTableCell('السعر', isHeader: true)),
          Expanded(child: _buildTableCell('الكمية', isHeader: true)),
          Expanded(child: _buildTableCell('الصنف', isHeader: true)),
        ],
      ),
    );
  }

  Widget _buildDataRow(BuildContext context, SaleRecord item) {
    return FutureBuilder<double?>(
      future: FirebaseDatabase.getCosteByName(item.itemName),
      builder: (context, snapshot) {
        final cost = snapshot.data ?? 0.0;

        return InkWell(
          onTap: () {
            Dialogs.materialDialog(
              dialogWidth: 300,
              color: Colors.white,
              msg: 'Want to return all quality items?',
              title: 'Return item',
              lottieBuilder: LottieBuilder.asset(
                'images/return.json',
                fit: BoxFit.contain,
              ),
              context: context,
              actions: [
                IconsButton(
                  padding: EdgeInsets.all(20),
                  onPressed: () {
                    FirebaseOperations.returnSaleRecord(item.docId!, context);
                    Navigator.pop(context);
                  },
                  text: 'Return',
                  iconData: Icons.done,
                  color: Colors.blue,
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
                  color: Colors.red,
                  textStyle: const TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                ),
              ],
            );
          },
          child: Row(
            children: [
              Expanded(
                  child: _buildTableCell((item.salePrice - cost).toString())),
              Expanded(child: _buildTableCell(item.salePrice.toString())),
              Expanded(child: _buildTableCell(item.quantitySold.toString())),
              Expanded(child: _buildTableCell(item.itemName)),
            ],
          ),
        );
      },
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
