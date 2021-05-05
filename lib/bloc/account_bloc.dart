import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:save_my_password/event_state/account_event.dart';
import 'package:save_my_password/event_state/account_state.dart';
import 'package:save_my_password/models/account_model.dart';
import 'package:save_my_password/services/account_services.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountService _accountService = AccountService();

  AccountBloc() : super(AccountUninitialized()) {
    this.add(AccountGetsData());
  }

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    try {
      if (_accountService.db == null) {
        await _accountService.init();
      }

      if (event is AccountSaveData) {
        await _accountService.insert(event.account);

        yield AccountModifyDataSuccess(message: 'Success to save data');

        this.add(AccountGetsData());
      }

      if (event is AccountUpdateData) {
        await _accountService.update(event.account);

        yield AccountModifyDataSuccess(message: 'Success to update data');

        this.add(AccountGetsData());
      }

      if (event is AccountDeleteData) {
        await _accountService.delete(event.account);

        yield AccountModifyDataSuccess(message: 'Success to delete data');

        this.add(AccountGetsData());
      }

      if (event is AccountGetsData) {
        List<AccountModel> accountModels = [];

        // for the combo box
        List<AccountModel> filterAccountModels =
            await _accountService.getsData();

        if (event.isAll) {
          accountModels = await _accountService.getsData();
        } else {
          accountModels = await _accountService.getData(event.accountFilter);
        }

        yield AccountGetsDataSuccess(
            accountModels: accountModels,
            filterAccountModels: filterAccountModels);
      }

      if (event is AccountBackupData) {
        List<AccountModel> accountModels = await _accountService.getsData();
        List<List<dynamic>> csvData = accountModels.map((e) {
          return [
            e.account.toString(),
            e.username.toString(),
            e.password.toString(),
          ]..add('n\n');
        }).toList();
        String res = ListToCsvConverter().convert(csvData);

        DateTime now = DateTime.now();
        DateFormat formatter = DateFormat('yyyy-MM-dd HH.mm');
        String formatted = formatter.format(now);
        String filename = 'BACKUP - Save My Password ($formatted).csv';
        String path = event.path + '\\' + filename;

        File file = File(path);
        await file.writeAsString(res);

        yield AccountModifyDataSuccess(message: 'Success to backup data');

        yield AccountGetsDataSuccess(
            accountModels: accountModels, filterAccountModels: accountModels);
      }

      if (event is AccountRestoreData) {
        File file = File(event.filePath);
        String contents = await file.readAsString();
        List<List<dynamic>> csvData = CsvToListConverter().convert(contents);
        List<AccountModel> data = csvData.map((e) {
          return AccountModel(
            account: e[0],
            username: e[1],
            password: e[2],
          );
        }).toList();

        await _accountService.batchInsert(data);

        yield AccountModifyDataSuccess(message: 'Success to restore data');

        this.add(AccountGetsData());
      }
    } catch (e) {
      print(e);

      yield AccountError(message: e.toString());
    }
  }
}
