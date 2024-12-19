import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:phone_store/Classes/service_class.dart';
import 'package:phone_store/Data/data_sales_layer.dart';

class ServiceCard extends StatelessWidget {
  final List<ServiceRecord> services;

  ServiceCard({required this.services});

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
                  for (var service in services) _buildDataRow(context, service),
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
          Expanded(child: _buildTableCell('الكمية', isHeader: true)),
          Expanded(child: _buildTableCell('الصنف', isHeader: true)),
        ],
      ),
    );
  }

  Widget _buildDataRow(BuildContext context, ServiceRecord service) {
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
                FirebaseOperations.returnSaleRecord(service.docId!, context);

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
          Expanded(child: _buildTableCell(service.money.toString())),
          Expanded(child: _buildTableCell(service.serviceType)),
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
