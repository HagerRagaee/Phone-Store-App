part of 'wallet_cubit.dart';

@immutable
sealed class WalletState {}

final class WalletInitial extends WalletState {}

class WalletSaved extends WalletState {}

class WalletFailure extends WalletState {
  final String errorMessage;
  WalletFailure(this.errorMessage);
}

class WalletFetched extends WalletState {
  final List<WalletData> Wallet;
  WalletFetched(this.Wallet);
}

class WalletSearched extends WalletState {
  final List<WalletData> Wallet;
  WalletSearched(this.Wallet);
}

class WalletFetchedPhonesNumber extends WalletState {
  final List<String> PhoneNumber;
  WalletFetchedPhonesNumber(this.PhoneNumber);
}

class WalletCounterUpdated extends WalletState {
  final int counter;
  final String docId;
  WalletCounterUpdated(this.counter, this.docId);
}

class WalletCounterFetched extends WalletState {
  final int counter;
  final String docId;
  WalletCounterFetched(this.counter, this.docId);
}

class WalletFetchedOne extends WalletState {
  final WalletData Wallet;
  WalletFetchedOne(this.Wallet);
}

class WalletUpdated extends WalletState {
  final String walletId;
  WalletUpdated(this.walletId);
}

class WalletDeleted extends WalletState {
  final String walletId;
  WalletDeleted(this.walletId);
}

class WalletReturned extends WalletState {}

class WalletReset extends WalletState {}
