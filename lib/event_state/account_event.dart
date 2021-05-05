import 'package:equatable/equatable.dart';
import 'package:save_my_password/models/account_model.dart';

abstract class AccountEvent extends Equatable {
  AccountEvent();
}

class AccountGetsData extends AccountEvent {
  final bool isAll;
  final String accountFilter;

  AccountGetsData({this.isAll = true, this.accountFilter = ''});

  @override
  List<Object?> get props => [isAll, accountFilter];
}

class AccountSaveData extends AccountEvent {
  final AccountModel account;

  AccountSaveData({required this.account});

  @override
  List<Object?> get props => [account];
}

class AccountUpdateData extends AccountEvent {
  final AccountModel account;

  AccountUpdateData({required this.account});

  @override
  List<Object?> get props => [account];
}

class AccountDeleteData extends AccountEvent {
  final AccountModel account;

  AccountDeleteData({required this.account});

  @override
  List<Object?> get props => [account];
}

class AccountBackupData extends AccountEvent {
  final String path;

  AccountBackupData({required this.path});
  @override
  List<Object?> get props => [path];
}

class AccountRestoreData extends AccountEvent {
  final String filePath;

  AccountRestoreData({required this.filePath});
  @override
  List<Object?> get props => [filePath];
}
