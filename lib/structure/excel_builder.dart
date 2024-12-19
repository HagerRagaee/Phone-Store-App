import 'package:phone_store/Classes/store_item_class.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

class InventoryToExcel {
  static Future<void> createExcelFile(List<StoreItem> data) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    // Create a style with a yellow background for the header
    final Style headerStyle = workbook.styles.add('headerStyle');
    headerStyle.backColor = '#FFFF00'; // Yellow color

    // Create styles for alternating row colors
    final Style greyRowStyle = workbook.styles.add('greyRowStyle');
    greyRowStyle.backColor = '#D3D3D3'; // Light grey color

    final Style lightGreyRowStyle = workbook.styles.add('lightGreyRowStyle');
    lightGreyRowStyle.backColor = '#F0F0F0'; // Lighter grey color

    // Set headers with the style
    sheet.getRangeByName('S2').setText('الصنف'); // Item Name
    sheet.getRangeByName('Q2').setText('التكلفه'); // Cost
    sheet.getRangeByName('P2').setText('الكميه'); // Quantity
    // sheet.getRangeByName('P2').setText('الربح'); // Profit

    sheet.getRangeByName('P2:S2').cellStyle = headerStyle;

    for (int i = 0; i < data.length; i++) {
      final rowIndex = i + 3;

      // Set item data in cells (starting from column P)
      // sheet
      //     .getRangeByIndex(rowIndex, 16)
      //     .setNumber(data[i].calculateProfit()); // Column P (16)
      sheet
          .getRangeByIndex(rowIndex, 16)
          .setValue(data[i].quantity); // Column Q (17)
      sheet
          .getRangeByIndex(rowIndex, 17)
          .setNumber(data[i].itemCost); // Column R (18)

      sheet
          .getRangeByIndex(rowIndex, 18)
          .setText(data[i].itemName); // Column T (20)

      if (i % 2 == 0) {
        // Apply grey for even rows
        sheet.getRangeByIndex(rowIndex, 16).cellStyle = greyRowStyle;
        sheet.getRangeByIndex(rowIndex, 17).cellStyle = greyRowStyle;
        sheet.getRangeByIndex(rowIndex, 18).cellStyle = greyRowStyle;
        // sheet.getRangeByIndex(rowIndex, 19).cellStyle = greyRowStyle;
      } else {
        // Apply light grey for odd rows
        sheet.getRangeByIndex(rowIndex, 16).cellStyle = lightGreyRowStyle;
        sheet.getRangeByIndex(rowIndex, 17).cellStyle = lightGreyRowStyle;
        sheet.getRangeByIndex(rowIndex, 18).cellStyle = lightGreyRowStyle;
        // sheet.getRangeByIndex(rowIndex, 19).cellStyle = lightGreyRowStyle;
      }
    }

    // Save the workbook
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    if (kIsWeb) {
      AnchorElement(
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'Inventory.xlsx')
        ..click();
    } else {
      final String path = (await getApplicationSupportDirectory()).path;
      final String fileName = "$path/drivers_data.xlsx";
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(fileName);
    }
  }
}
