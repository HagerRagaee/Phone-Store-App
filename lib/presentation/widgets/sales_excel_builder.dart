// ignore_for_file: unnecessary_string_interpolations, avoid_print

import 'package:phone_store/data/models/balance_model.dart';
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
  static Future<void> createExcelFile(List<SaleRecord> data,
      List<ServiceRecord> service, List<BalanceModel> balance) async {
    try {
      print(balance.length);
      if (data.isEmpty && service.isEmpty && balance.isEmpty) {
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

      sheet.getRangeByName('I2').setText('الربح'); // Profit
      sheet.getRangeByName('J2').setText('المبلغ المحول'); // Transferred Amount
      sheet.getRangeByName('K2').setText('المبلغ الدفوع'); // Paid Amount
      sheet.getRangeByName('L2').setText('بيان'); // Statement
      sheet.getRangeByName('M2').setText('محفظه'); // Wallet

      sheet.getRangeByName('O2').setText('الربح'); // Profit (Sales)
      sheet.getRangeByName('P2').setText('التكلفه'); // Cost
      sheet.getRangeByName('Q2').setText('الكميه'); // Quantity
      sheet.getRangeByName('R2').setText('سعر البيع'); // Sale Price
      sheet.getRangeByName('S2').setText('الصنف'); // Item

      sheet.getRangeByName('I2:M2').cellStyle = headerStyle;
      sheet.getRangeByName('O2:S2').cellStyle = headerStyle;

      double totalProfitService = 0;
      double totalCostService = 0;
      double totalServices = 0;
      double totalProfitSales = 0;
      double totalCostSales = 0;

      for (int i = 0; i < service.length; i++) {
        final rowIndex = i + 3;
        final double profit = service[i].money - service[i].cost;
        final double transferredAmount = service[i].cost;

        sheet.getRangeByIndex(rowIndex, 9).setNumber(profit);
        sheet.getRangeByIndex(rowIndex, 10).setNumber(transferredAmount);
        sheet.getRangeByIndex(rowIndex, 11).setNumber(service[i].money);
        sheet.getRangeByIndex(rowIndex, 12).setText(service[i].serviceType);
        sheet.getRangeByIndex(rowIndex, 13).setValue(service[i].phoneNumber);

        totalProfitService += profit;
        totalCostService += transferredAmount;
        totalServices += service[i].money;

        final Style rowStyle = (i % 2 == 0) ? greyRowStyle : lightGreyRowStyle;
        for (int col = 9; col <= 13; col++) {
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

        final rowIndex = i + 3;
        sheet.getRangeByIndex(rowIndex, 15).setNumber(profit); // Profit
        sheet.getRangeByIndex(rowIndex, 16).setNumber(totalCost); // Cost
        sheet.getRangeByIndex(rowIndex, 17).setValue(quantitySold); // Quantity
        sheet.getRangeByIndex(rowIndex, 18).setNumber(salePrice); // Sale Price
        sheet
            .getRangeByIndex(rowIndex, 19)
            .setText(data[i].itemName); // Item Name

        totalProfitSales += profit;
        totalCostSales += totalCost;

        final Style rowStyle = (i % 2 == 0) ? greyRowStyle : lightGreyRowStyle;
        for (int col = 15; col <= 19; col++) {
          sheet.getRangeByIndex(rowIndex, col).cellStyle = rowStyle;
        }
      }

      // Add Total Row
      final int totalRowIndex = service.length + 3;
      sheet.getRangeByIndex(totalRowIndex, 9).setNumber(totalProfitService);
      sheet.getRangeByIndex(totalRowIndex, 10).setNumber(totalCostService);
      sheet.getRangeByIndex(totalRowIndex, 11).setNumber(totalServices);
      sheet.getRangeByIndex(totalRowIndex, 13).setText("الاجمالي");

      sheet.getRangeByIndex(totalRowIndex, 9).cellStyle = totalRowStyle;
      sheet.getRangeByIndex(totalRowIndex, 10).cellStyle = totalRowStyle;
      sheet.getRangeByIndex(totalRowIndex, 11).cellStyle = totalRowStyle;
      sheet.getRangeByIndex(totalRowIndex, 12).cellStyle = totalRowStyle;

      sheet.getRangeByIndex(totalRowIndex, 13).cellStyle = totalRowStyle;

      final int totalSalesRowIndex = data.length + 3;
      sheet.getRangeByIndex(totalSalesRowIndex, 15).setNumber(totalProfitSales);
      sheet.getRangeByIndex(totalSalesRowIndex, 16).setNumber(totalCostSales);
      sheet.getRangeByIndex(totalSalesRowIndex, 19).setText("الاجمالي");

      sheet.getRangeByIndex(totalSalesRowIndex, 15).cellStyle = totalRowStyle;
      sheet.getRangeByIndex(totalSalesRowIndex, 16).cellStyle = totalRowStyle;
      sheet.getRangeByIndex(totalSalesRowIndex, 17).cellStyle = totalRowStyle;
      sheet.getRangeByIndex(totalSalesRowIndex, 18).cellStyle = totalRowStyle;
      sheet.getRangeByIndex(totalSalesRowIndex, 19).cellStyle = totalRowStyle;

      sheet.getRangeByName('D2').setText('الربح');
      sheet.getRangeByName('E2').setText('لتكلفه');
      sheet.getRangeByName('F2').setText('السعر');
      sheet.getRangeByName('G2').setText('بيان');

      sheet.getRangeByName('D2:G2').cellStyle = headerStyle;

      // Updated Balance Section Logic
      double totalProfitBalance = 0;
      double totalCostBalance = 0;
      double totalPriceBalance = 0;

// Start populating balance rows
      for (int i = 0; i < balance.length; i++) {
        final rowIndex = i + 3; // Starting from row 3 to avoid header row

        // Populate balance data into respective columns
        final double profit = balance[i].profit;
        sheet.getRangeByIndex(rowIndex, 4).setNumber(profit); // Profit
        sheet.getRangeByIndex(rowIndex, 5).setNumber(balance[i].cost); // Cost
        sheet.getRangeByIndex(rowIndex, 6).setNumber(balance[i].price); // Price
        sheet.getRangeByIndex(rowIndex, 7).setText(balance[i].type);

        totalProfitBalance += profit;
        totalCostBalance += balance[i].cost;
        totalPriceBalance += balance[i].price;

        final Style rowStyle = (i % 2 == 0) ? greyRowStyle : lightGreyRowStyle;
        for (int col = 4; col <= 7; col++) {
          sheet.getRangeByIndex(rowIndex, col).cellStyle = rowStyle;
        }
      }

      final int totalIndex = balance.length + 3;
      sheet.getRangeByIndex(totalIndex, 4).setNumber(totalProfitBalance);
      sheet.getRangeByIndex(totalIndex, 5).setNumber(totalCostBalance);
      sheet.getRangeByIndex(totalIndex, 6).setNumber(totalPriceBalance);
      sheet.getRangeByIndex(totalIndex, 7).setText("الاجمالي");

      for (int col = 4; col <= 7; col++) {
        sheet.getRangeByIndex(totalIndex, col).cellStyle = totalRowStyle;
      }

      double totalProfit =
          totalProfitService + totalProfitSales + totalProfitBalance;
      sheet.getRangeByIndex(3, 1, 5, 1).merge();
      sheet.getRangeByIndex(3, 2, 5, 2).merge();

      sheet.getRangeByIndex(3, 1).setText("${totalProfit.toStringAsFixed(2)}");
      sheet.getRangeByIndex(3, 1, 5, 2).merge();

      sheet.getRangeByIndex(3, 1).cellStyle.backColor = '#000000';
      sheet.getRangeByIndex(3, 1).cellStyle.fontColor = '#FFFFFF';

      sheet.getRangeByIndex(3, 1).cellStyle.hAlign = HAlignType.center;
      sheet.getRangeByIndex(3, 1).cellStyle.vAlign = VAlignType.center;

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
