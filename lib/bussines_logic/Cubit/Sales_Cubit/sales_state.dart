import 'package:phone_store/data/models/sales_class.dart';

abstract class SalesState {}

class SalesLoading extends SalesState {}

class SalesSaved extends SalesState {}

class SalesFailure extends SalesState {
  final String errorMessage;
  SalesFailure(this.errorMessage);
}

class SalesFetched extends SalesState {
  final List<SaleRecord> sales;
  SalesFetched(this.sales);
}

class SalesUpdated extends SalesState {
  final SaleRecord updatedSale;
  SalesUpdated(this.updatedSale);
}

class SalesDeleted extends SalesState {
  final String saleId;
  SalesDeleted(this.saleId);
}
