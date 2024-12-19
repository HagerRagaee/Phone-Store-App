import 'package:phone_store/Classes/sales_class.dart';
import 'package:phone_store/Classes/service_class.dart';
import 'package:phone_store/Data/data_inventory_layer.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

class SalesToExcel {
  static Future<void> createExcelFile(
      List<SaleRecord> data, List<ServiceRecord> service) async {
    try {
      if (data.isEmpty && service.isEmpty) {
        print("No sales data available to export.");
        return;
      }

      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Style headerStyle = workbook.styles.add('headerStyle');
      headerStyle.backColor = '#FFFF00';
      headerStyle.hAlign = HAlignType.center;
      headerStyle.vAlign = VAlignType.center;

      final Style greyRowStyle = workbook.styles.add('greyRowStyle');
      greyRowStyle.backColor = '#D3D3D3';
      greyRowStyle.hAlign = HAlignType.center;
      greyRowStyle.vAlign = VAlignType.center;

      final Style lightGreyRowStyle = workbook.styles.add('lightGreyRowStyle');
      lightGreyRowStyle.backColor = '#F0F0F0';
      lightGreyRowStyle.hAlign = HAlignType.center;
      lightGreyRowStyle.vAlign = VAlignType.center;

      // Set Headers
      sheet.getRangeByName('R2').setText('الصنف');
      sheet.getRangeByName('P2').setText('الكميه'); // Item Name
      sheet.getRangeByName('Q2').setText('سعر البيع');
      sheet.getRangeByName('O2').setText('التكلفه');
      sheet.getRangeByName('N2').setText('الربح'); // Quantity

      sheet.getRangeByName('N2:R2').cellStyle = headerStyle;

      sheet.getRangeByName('L2').setText('محفظه'); // Item Name
      sheet.getRangeByName('K2').setText('بيان'); // Item Name
      sheet.getRangeByName('J2').setText('السعر'); // Price
      sheet.getRangeByName('I2').setText('التكلفه');
      sheet.getRangeByName('H2').setText('الربح');

      sheet.getRangeByName('H2:L2').cellStyle = headerStyle;

      // Populate Rows for Service
      for (int i = 0; i < service.length; i++) {
        final rowIndex = i + 3; // Data starts from row 3
        final double money = service[i].money;
        final double cost = service[i].cost;

        sheet
            .getRangeByIndex(rowIndex, 12)
            .setValue(service[i].phoneNumber); // Column I
        sheet
            .getRangeByIndex(rowIndex, 11)
            .setText(service[i].serviceType); // Column J
        sheet.getRangeByIndex(rowIndex, 10).setNumber(money); // Column K
        sheet.getRangeByIndex(rowIndex, 9).setNumber(money - cost); // Column L
        sheet.getRangeByIndex(rowIndex, 8).setNumber(cost); // Column M

        // Apply Row Styles
        final Style rowStyle = (i % 2 == 0) ? greyRowStyle : lightGreyRowStyle;
        sheet.getRangeByIndex(rowIndex, 8).cellStyle = rowStyle;
        sheet.getRangeByIndex(rowIndex, 9).cellStyle = rowStyle;
        sheet.getRangeByIndex(rowIndex, 10).cellStyle = rowStyle;
        sheet.getRangeByIndex(rowIndex, 11).cellStyle = rowStyle;
        sheet.getRangeByIndex(rowIndex, 12).cellStyle = rowStyle;
      }

      // Populate Rows for Sales Data
      for (int i = 0; i < data.length; i++) {
        final double cost =
            (await FirebaseDatabase.getCosteByName(data[i].itemName)) ?? 0.0;
        final double salePrice = data[i].salePrice;
        final int quantitySold = data[i].quantitySold;

        final rowIndex = i + 3;

        // Set cell values
        sheet
            .getRangeByIndex(rowIndex, 14)
            .setValue(salePrice - cost); // Profit (Sale Price - Cost)
        sheet.getRangeByIndex(rowIndex, 15).setValue(cost); // Cost
        sheet
            .getRangeByIndex(rowIndex, 16)
            .setValue(quantitySold); // Quantity Sold
        sheet.getRangeByIndex(rowIndex, 17).setNumber(salePrice); // Sale Price
        sheet
            .getRangeByIndex(rowIndex, 18)
            .setText(data[i].itemName); // Item Name

        // Apply Row Styles
        final Style rowStyle = (i % 2 == 0) ? greyRowStyle : lightGreyRowStyle;
        sheet.getRangeByIndex(rowIndex, 14).cellStyle = rowStyle;
        sheet.getRangeByIndex(rowIndex, 15).cellStyle = rowStyle;
        sheet.getRangeByIndex(rowIndex, 16).cellStyle = rowStyle;
        sheet.getRangeByIndex(rowIndex, 17).cellStyle = rowStyle;
        sheet.getRangeByIndex(rowIndex, 18).cellStyle = rowStyle;
      }

      // Save the file
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      if (kIsWeb) {
        AnchorElement(
            href:
                'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
          ..setAttribute(
              'download', 'Sales_${DateTime.now().millisecondsSinceEpoch}.xlsx')
          ..click();
      } else {
        final String path = (await getApplicationDocumentsDirectory()).path;
        final String fileName = "$path/sales_${DateTime.now().day}.xlsx";
        print("Saving Sales Excel at: $fileName");
        final File file = File(fileName);
        await file.writeAsBytes(bytes, flush: true);
        OpenFile.open(fileName);
      }

      print("Sales Excel file created successfully!");
    } catch (e) {
      print("Error creating Sales Excel file: $e");
    }
  }
}
