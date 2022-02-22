import 'package:equatable/equatable.dart';
import 'package:save_my_password/models/account.dart';

abstract class AccountState extends Equatable {
  AccountState();
}

class AccountUninitialized extends AccountState {
  @override
  List<Object?> get props => [];
}

class AccountGetsDataSuccess extends AccountState {
  final List<Account> accounts;

  AccountGetsDataSuccess({
    required this.accounts,
  });

  @override
  List<Object?> get props => [accounts];
}

class AccountError extends AccountState {
  @override
  List<Object?> get props => [];
}
