import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import '../../data/models/service_class.dart';
import '../../bussines_logic/Cubit/Service_Cubit/service_cubit.dart';
import 'package:phone_store/presentation/widgets/service_builder.dart';

class ServiceCard extends StatelessWidget {
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
                  for (var service
                      in BlocProvider.of<ServiceCubit>(context).services)
                    _buildDataRow(context, service),
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
          Expanded(child: _buildTableCell('المبلغ المدفوع', isHeader: true)),
          Expanded(child: _buildTableCell('المبلغ المحول', isHeader: true)),
          Expanded(child: _buildTableCell('نوع العمليه', isHeader: true)),
          Expanded(child: _buildTableCell('رقم المحفظه', isHeader: true)),
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
                bool removed = await BlocProvider.of<ServiceCubit>(context)
                    .removeService(service.docId!, context);
                if (removed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("تم حذف السجل بنجاح"),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text("خطأ: فشل حذف عمليه ال${service.serviceType}"),
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
                    builder: (context) => ServiceBuilder(
                      service: service,
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
          Expanded(child: _buildTableCell((service.cost).toString())),
          Expanded(child: _buildTableCell((service.money).toString())),
          Expanded(
              child:
                  _buildTableCell((service.money - service.cost).toString())),
          Expanded(child: _buildTableCell(service.serviceType)),
          Expanded(child: _buildTableCell(service.phoneNumber)),
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
