import 'package:phone_store/data/models/balance_model.dart';

abstract class BalanceState {}

class BalanceLoading extends BalanceState {}

class BalanceSaved extends BalanceState {}

class BalanceFailure extends BalanceState {
  final String errorMessage;
  BalanceFailure(this.errorMessage);
}

class BalanceFetched extends BalanceState {
  final List<BalanceModel> Balance;
  BalanceFetched(this.Balance);
}

class BalanceDeleted extends BalanceState {
  final String saleId;
  BalanceDeleted(this.saleId);
}

class BalanceFetchedRecord extends BalanceState {
  final BalanceModel balance;
  BalanceFetchedRecord(this.balance);
}
