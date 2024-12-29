// sales_state.dart

import 'package:phone_store/Classes/sales_class.dart';

abstract class SalesState {}

class SalesInitial extends SalesState {}

class SalesLoading extends SalesState {}

class SalesSuccess extends SalesState {}

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
