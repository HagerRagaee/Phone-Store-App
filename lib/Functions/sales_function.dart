import 'package:phone_store/Classes/sales_class.dart';
import 'package:phone_store/Data/data_inventory_layer.dart';

double calculateTotalSales(List<SaleRecord> _items) {
  double totalSales = 0;
  for (var sale in _items) {
    totalSales += sale.salePrice;
  }
  return totalSales;
}

Future<double> calculateTotalProfit(List<SaleRecord> _items) async {
  double totalProfit = 0;
  for (var sale in _items) {
    double? cost = await FirebaseDatabase.getCosteByName(sale.itemName) ?? 0;
    double? profit = sale.salePrice - cost;

    totalProfit += profit * sale.quantitySold;
  }
  return totalProfit;
}
