import 'package:phone_store/data/models/sales_class.dart';
import 'package:phone_store/data/models/service_class.dart';
import 'package:phone_store/data/firebase_data/data_inventory_layer.dart';
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

      FirebaseDatabase firebaseDatabase = FirebaseDatabase();
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

      final Style totalRowStyle = workbook.styles.add('totalRowStyle');
      totalRowStyle.backColor = '#FFA500';
      totalRowStyle.hAlign = HAlignType.center;
      totalRowStyle.vAlign = VAlignType.center;
      totalRowStyle.bold = true;

      // Set Headers
      sheet.getRangeByName('H2').setText('الربح'); // Profit
      sheet.getRangeByName('I2').setText('المبلغ المحول'); // Transferred Amount
      sheet.getRangeByName('J2').setText('المبلغ الدفوع'); // Paid Amount
      sheet.getRangeByName('K2').setText('بيان'); // Statement
      sheet.getRangeByName('L2').setText('محفظه'); // Wallet
      sheet.getRangeByName('N2').setText('الربح'); // Profit (Sales)
      sheet.getRangeByName('O2').setText('التكلفه'); // Cost
      sheet.getRangeByName('P2').setText('الكميه'); // Quantity
      sheet.getRangeByName('Q2').setText('سعر البيع'); // Sale Price
      sheet.getRangeByName('R2').setText('الصنف'); // Item

      sheet.getRangeByName('H2:L2').cellStyle = headerStyle;
      sheet.getRangeByName('N2:R2').cellStyle = headerStyle;

      double totalProfitService = 0;
      double totalCostService = 0;
      double totalServices = 0;
      double totalProfitSales = 0;
      double totalCostSales = 0;

      // Populate Rows for Service
      for (int i = 0; i < service.length; i++) {
        final rowIndex = i + 3; // Data starts from row 3
        final double transferredAmount = service[i].money - service[i].cost;
        final double profit = service[i].cost;

        sheet.getRangeByIndex(rowIndex, 8).setNumber(profit); // Profit
        sheet
            .getRangeByIndex(rowIndex, 9)
            .setNumber(transferredAmount); // Transferred Amount
        sheet
            .getRangeByIndex(rowIndex, 10)
            .setNumber(service[i].money); // Paid Amount
        sheet
            .getRangeByIndex(rowIndex, 11)
            .setText(service[i].serviceType); // Statement
        sheet
            .getRangeByIndex(rowIndex, 12)
            .setValue(service[i].phoneNumber); // Wallet

        totalProfitService += profit;
        totalCostService += transferredAmount;
        totalServices += service[i].money;

        final Style rowStyle = (i % 2 == 0) ? greyRowStyle : lightGreyRowStyle;
        for (int col = 8; col <= 12; col++) {
          sheet.getRangeByIndex(rowIndex, col).cellStyle = rowStyle;
        }
      }

      // Populate Rows for Sales Data
      for (int i = 0; i < data.length; i++) {
        final double cost =
            (await firebaseDatabase.getCosteByName(data[i].itemName)) ?? 0.0;
        final double salePrice = data[i].salePrice;
        final int quantitySold = data[i].quantitySold;
        final double profit = (salePrice - (quantitySold * cost));
        final double totalCost = cost * quantitySold;

        final rowIndex = data.length + i + 2;
        sheet.getRangeByIndex(rowIndex, 14).setNumber(profit); // Profit
        sheet.getRangeByIndex(rowIndex, 15).setNumber(totalCost); // Cost
        sheet.getRangeByIndex(rowIndex, 16).setValue(quantitySold); // Quantity
        sheet.getRangeByIndex(rowIndex, 17).setNumber(salePrice); // Sale Price
        sheet
            .getRangeByIndex(rowIndex, 18)
            .setText(data[i].itemName); // Item Name

        totalProfitSales += profit;
        totalCostSales += totalCost;

        final Style rowStyle = (i % 2 == 0) ? greyRowStyle : lightGreyRowStyle;
        for (int col = 14; col <= 18; col++) {
          sheet.getRangeByIndex(rowIndex, col).cellStyle = rowStyle;
        }
      }

      // Add Total Row
      final int totalRowIndex = service.length + 3;
      sheet.getRangeByIndex(totalRowIndex, 8).setNumber(totalProfitService);
      sheet.getRangeByIndex(totalRowIndex, 9).setNumber(totalCostService);
      sheet.getRangeByIndex(totalRowIndex, 10).setNumber(totalServices);
      sheet.getRangeByIndex(totalRowIndex, 12).setText("الاجمالي");

      sheet.getRangeByIndex(totalRowIndex, 8).cellStyle = totalRowStyle;
      sheet.getRangeByIndex(totalRowIndex, 9).cellStyle = totalRowStyle;
      sheet.getRangeByIndex(totalRowIndex, 10).cellStyle = totalRowStyle;
      sheet.getRangeByIndex(totalRowIndex, 11).cellStyle = totalRowStyle;

      sheet.getRangeByIndex(totalRowIndex, 12).cellStyle = totalRowStyle;

      final int totalSalesRowIndex = data.length + 3;
      sheet.getRangeByIndex(totalSalesRowIndex, 14).setNumber(totalProfitSales);
      sheet.getRangeByIndex(totalSalesRowIndex, 15).setNumber(totalCostSales);
      sheet.getRangeByIndex(totalSalesRowIndex, 18).setText("الاجمالي");

      sheet.getRangeByIndex(totalSalesRowIndex, 14).cellStyle = totalRowStyle;
      sheet.getRangeByIndex(totalSalesRowIndex, 15).cellStyle = totalRowStyle;
      sheet.getRangeByIndex(totalSalesRowIndex, 16).cellStyle = totalRowStyle;
      sheet.getRangeByIndex(totalSalesRowIndex, 17).cellStyle = totalRowStyle;
      sheet.getRangeByIndex(totalSalesRowIndex, 18).cellStyle = totalRowStyle;

      double totalProfit = totalProfitService + totalProfitSales;
      sheet.getRangeByIndex(3, 2, 5, 2).merge();
      sheet.getRangeByIndex(3, 3, 5, 3).merge();

      sheet.getRangeByIndex(3, 2).setText("${totalProfit.toStringAsFixed(2)}");
      sheet.getRangeByIndex(3, 2, 5, 3).merge();

      sheet.getRangeByIndex(3, 2).cellStyle.backColor = '#000000';
      sheet.getRangeByIndex(3, 2).cellStyle.fontColor = '#FFFFFF';

      sheet.getRangeByIndex(3, 2).cellStyle.hAlign = HAlignType.center;
      sheet.getRangeByIndex(3, 2).cellStyle.vAlign = VAlignType.center;

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      if (kIsWeb) {
        AnchorElement(
            href:
                'data:application/octet-stream;base64,${base64.encode(bytes)}')
          ..setAttribute(
              'download', 'Sales_${DateTime.now().millisecondsSinceEpoch}.xlsx')
          ..click();
      } else {
        final String path = (await getApplicationDocumentsDirectory()).path;
        final String fileName = "$path/sales_${DateTime.now().day}.xlsx";
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
