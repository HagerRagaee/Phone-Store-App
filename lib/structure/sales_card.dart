import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:phone_store/Classes/sales_class.dart';
import 'package:phone_store/Data/data_inventory_layer.dart';
import 'package:phone_store/Statemangement/Cubit/Sales_Cubit/sales_cubit.dart';
import 'package:phone_store/structure/sell_item_builder.dart';

class SalesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<SaleRecord> items = BlocProvider.of<SalesCubit>(context).items;
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
          Expanded(child: _buildTableCell('سعر البيع', isHeader: true)),
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
                    BlocProvider.of<SalesCubit>(context)
                        .returnSaleRecord(item.docId!, context);
                    Navigator.pop(context);
                  },
                  text: 'Return',
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
                        builder: (context) => SellItemBuilder(
                          item: item,
                          update: true,
                        ),
                      ),
                    );
                  },
                  text: 'Update',
                  color: Colors.blue,
                  textStyle: const TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                ),
              ],
            );
          },
          child: Row(
            children: [
              Expanded(
                  child: _buildTableCell(
                      ((item.salePrice) - (item.quantitySold * cost))
                          .toString())),
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
