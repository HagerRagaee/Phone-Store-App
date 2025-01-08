import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_store/data/models/sales_class.dart';
import 'package:phone_store/bussines_logic/Cubit/Sales_Cubit/sales_state.dart';
import 'package:phone_store/data/repository/sales_repository.dart';

class SalesCubit extends Cubit<SalesState> {
  SalesCubit(this.repository) : super(SalesLoading());

  List<SaleRecord> sales = [];
  final SalesRepository repository;

  void saveSaleRecord(SaleRecord sale, BuildContext context) {
    try {
      repository.saveSaleRecord(sale, context);
      emit((SalesSaved()));
    } catch (error) {
      emit(SalesFailure(error.toString()));
    }
  }

  List<SaleRecord> getTodaySales() {
    try {
      repository.getTodaySales().then((sales) {
        emit(SalesFetched(sales));
        this.sales = sales;
      });

      return sales;
    } catch (e) {
      emit(SalesFailure(e.toString()));
      return [];
    }
  }

  List<SaleRecord> getSalesByDate(List<DateTime?> dates) {
    try {
      repository.getSalesByDate(dates).then((sales) {
        emit(SalesFetched(sales));
        this.sales = sales;
      });

      return sales;
    } catch (e) {
      emit(SalesFailure(e.toString()));
      return [];
    }
  }

  List<SaleRecord> getSalesByOneDate(DateTime? date) {
    try {
      repository.getSalesByOneDate(date).then((sales) {
        emit(SalesFetched(sales));
        this.sales = sales;
      });

      return sales;
    } catch (e) {
      emit(SalesFailure(e.toString()));
      return [];
    }
  }

  void returnSaleRecord(String saleId, BuildContext context) {
    try {
      repository.returnSaleRecord(saleId, context);
      emit((SalesDeleted(saleId)));
    } catch (error) {
      emit(SalesFailure(error.toString()));
    }
  }

  void updateSaleRecord(
      SaleRecord oldSale, SaleRecord updatedSale, BuildContext context) {
    try {
      repository.updateSaleRecord(oldSale, updatedSale, context);
      emit((SalesUpdated(updatedSale)));
    } catch (error) {
      emit(SalesFailure(error.toString()));
    }
  }
}
