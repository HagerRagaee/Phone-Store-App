// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:phone_store/data/models/wallet_class.dart';
import 'package:phone_store/data/repository/wallet_repository.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit(this.walletRepository) : super(WalletInitial());

  List<WalletData> wallets = [];
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

  Future<List<WalletData>> searchWallet(String searchController) async {
    try {
      if (searchController.isEmpty) {
        emit(WalletFetched(wallets));
        return wallets;
      } else {
        final searchedWallets =
            await walletRepository.searchWallet(searchController);

        emit(WalletSearched(searchedWallets));
        wallets = searchedWallets;
        return searchedWallets;
      }
    } catch (e) {
      emit(WalletFailure(e.toString()));
      return [];
    }
  }

  Future<bool> walletExists(String phoneNumber) async {
    final wallets = getAllWallet();

    return wallets.any((wallet) => wallet.phoneNumber == phoneNumber);
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

  void updateWalletCounter(String docId, int currentCounter) {
    try {
      walletRepository.updateWalletCounter(docId, currentCounter);
      emit(WalletCounterUpdated(currentCounter, docId));
    } catch (e) {
      emit(WalletFailure(e.toString()));
      return;
    }
  }

  int getWalletCounter(String docId) {
    try {
      walletRepository.getWalletCounter(docId).then((counter) {
        emit(WalletCounterFetched(counter, docId));
        return counter;
      });
      return 0;
    } catch (e) {
      emit(WalletFailure(e.toString()));
      return 0;
    }
  }
}
