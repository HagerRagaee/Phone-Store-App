import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:phone_store/data/models/wallet_class.dart';
import 'package:phone_store/data/repository/wallet_repository.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit(this.walletRepository) : super(WalletInitial());

  List<WalletData> wallets = [];
  List<String> phoneNumbers = [];
  WalletRepository walletRepository;
  late WalletData wallet;

  void addWallet(WalletData wallet) {
    try {
      walletRepository.addWallet(wallet);
      emit(WalletSaved());
    } catch (e) {
      emit(WalletFailure(e.toString()));
    }
  }

  List<WalletData> getAllWallet() {
    try {
      walletRepository.getAllWallet().then((wallets) => {
            emit(WalletFetched(wallets)),
            this.wallets = wallets,
          });
      return wallets;
    } catch (e) {
      emit(WalletFailure(e.toString()));
      return [];
    }
  }

  WalletData? getWalletById(String id) {
    try {
      walletRepository.getWalletById(id).then((wallet) => {
            emit(WalletFetchedOne(wallet!)),
            this.wallet = wallet,
          });
      return wallet;
    } catch (e) {
      emit(WalletFailure(e.toString()));
      return null;
    }
  }

  updateWallet(String id, double amount, double cost, String type,
      BuildContext context) {
    try {
      walletRepository.updateWallet(id, amount, cost, type, context);
      emit(WalletUpdated(id));
    } catch (e) {
      emit(WalletFailure(e.toString()));
      return;
    }
  }

  void returnWalletAmount(String id, double amount, double cost, String type,
      BuildContext context) {
    try {
      walletRepository.returnWalletAmount(id, amount, cost, type, context);
      emit(WalletReturned());
    } catch (e) {
      emit(WalletFailure(e.toString()));
      return;
    }
  }

  void deleteWallet(String docId) {
    try {
      walletRepository.deleteWallet(docId);
      emit(WalletDeleted(docId));
    } catch (e) {
      emit(WalletFailure(e.toString()));
      return;
    }
  }

  void resetWalletLimitsIfNeeded() {
    try {
      walletRepository.resetWalletLimitsIfNeeded();
      emit(WalletReset());
    } catch (e) {
      emit(WalletFailure(e.toString()));
      return;
    }
  }

  // List<String> getPhoneNumbers(BuildContext context) {
  //   try {
  //     walletRepository.getPhoneNumbers(context).then((phoneNumbers) => {
  //           emit(WalletFetchedPhonesNumber(phoneNumbers)),
  //           this.phoneNumbers = phoneNumbers,
  //         });
  //     return phoneNumbers;
  //   } catch (e) {
  //     emit(WalletFailure(e.toString()));
  //     return [];
  //   }
  // }
}
