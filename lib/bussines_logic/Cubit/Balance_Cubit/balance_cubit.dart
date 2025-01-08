import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:phone_store/bussines_logic/Cubit/Balance_Cubit/balance_state.dart';
import 'package:phone_store/data/models/balance_model.dart';
import 'package:phone_store/data/repository/balance_repository.dart';

class BalanceCubit extends Cubit<BalanceState> {
  BalanceCubit(this.repository) : super(BalanceLoading());

  List<BalanceModel> balanceRecordes = [];
  late BalanceModel? balance;
  final BalanceRepository repository;

  void addBalance(BalanceModel balanceModel, BuildContext context) async {
    try {
      emit(BalanceLoading());
      await repository.addBalance(balanceModel, context);
      emit(BalanceSaved());
      print(balanceRecordes.length);
    } catch (error) {
      emit(BalanceFailure(error.toString()));
    }
  }

  List<BalanceModel> getTodayBalances() {
    try {
      emit(BalanceLoading());
      repository.getTodayBalances().then((balanceRecordes) => {
            this.balanceRecordes = balanceRecordes,
            emit(BalanceFetched(balanceRecordes)),
          });
      return balanceRecordes;
    } catch (error) {
      emit(BalanceFailure(error.toString()));
      return [];
    }
  }

  List<BalanceModel> getBalanceByDate(List<DateTime?> dates) {
    try {
      emit(BalanceLoading());
      repository.getBalanceByDate(dates).then((balanceRecordes) => {
            this.balanceRecordes = balanceRecordes,
            emit(BalanceFetched(balanceRecordes)),
          });

      return balanceRecordes;
    } catch (error) {
      emit(BalanceFailure(error.toString()));
      return [];
    }
  }

  BalanceModel? getBalanceById(String id) {
    try {
      emit(BalanceLoading());
      repository.getBalanceById(id).then((balanceRecordes) => {
            this.balance = balanceRecordes,
            emit(BalanceFetchedRecord(balance!)),
          });
      print(balanceRecordes.length);

      return balance;
    } catch (error) {
      emit(BalanceFailure(error.toString()));
      return null;
    }
  }

  Future<bool> deleteBalanceRecord(
      String balanceId, BuildContext context) async {
    try {
      emit(BalanceDeleted(balanceId));
      return await repository.deleteBalanceRecord(balanceId, context);
    } catch (error) {
      emit(BalanceFailure(error.toString()));
      return false;
    }
  }
}
