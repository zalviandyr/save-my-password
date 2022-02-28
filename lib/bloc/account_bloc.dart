import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:save_my_password/bloc/bloc.dart';
import 'package:save_my_password/models/account.dart';
import 'package:save_my_password/services/account_dao.dart';
import 'package:save_my_password/services/database.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AppDatabase _database = GetIt.I<AppDatabase>();
  late AccountDao _accountDao;

  AccountBloc() : super(AccountUninitialized()) {
    _accountDao = _database.accountDao;
    on(_onAccountGetsData);
    on(_onAccountSaveData);
    on(_onAccountUpdateData);
    on(_onAccountDeleteData);
    on(_onAccountRestoreData);
  }

  Future _onAccountGetsData(
      AccountGetsData event, Emitter<AccountState> emit) async {
    List<Account> accounts = await _accountDao.findAllAccount();

    emit(AccountGetsDataSuccess(accounts: accounts));
    try {} catch (e) {
      log(e.toString(), name: '_onAccountGetsData');

      emit(AccountError());
    }
  }

  Future<void> _onAccountSaveData(
      AccountSaveData event, Emitter<AccountState> emit) async {
    try {
      await _accountDao.insertAccount(event.account);

      this.add(AccountGetsData());
    } catch (e) {
      log(e.toString(), name: '_onAccountSaveData');

      emit(AccountError());
    }
  }

  Future<void> _onAccountUpdateData(
      AccountUpdateData event, Emitter<AccountState> emit) async {
    try {
      await _accountDao.updateAccount(event.account);

      this.add(AccountGetsData());
    } catch (e) {
      log(e.toString(), name: '_onAccountUpdateData');

      emit(AccountError());
    }
  }

  Future<void> _onAccountDeleteData(
      AccountDeleteData event, Emitter<AccountState> emit) async {
    try {
      await _accountDao.deleteAccount(event.account);

      this.add(AccountGetsData());
    } catch (e) {
      log(e.toString(), name: '_onAccountDeleteData');

      emit(AccountError());
    }
  }

  Future<void> _onAccountRestoreData(
      AccountRestoreData event, Emitter<AccountState> emit) async {
    try {
      if (event.isFullRestore) {
        await _accountDao.deleteAllAccount();
      }

      await _accountDao.insertAccounts(event.accounts);

      this.add(AccountGetsData());
    } catch (e) {
      log(e.toString(), name: '_onAccountRestoreData');

      emit(AccountError());
    }
  }
}
