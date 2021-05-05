import 'package:equatable/equatable.dart';
import 'package:save_my_password/models/account_model.dart';

abstract class AccountState extends Equatable {
  AccountState();
}

class AccountUninitialized extends AccountState {
  @override
  List<Object?> get props => [];
}

class AccountModifyDataSuccess extends AccountState {
  final String message;

  AccountModifyDataSuccess({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() {
    return message;
  }
}

class AccountGetsDataSuccess extends AccountState {
  final List<AccountModel> accountModels;
  final List<AccountModel> filterAccountModels; // for the combo box

  AccountGetsDataSuccess({
    required this.accountModels,
    required this.filterAccountModels,
  });

  @override
  List<Object?> get props => [accountModels];
}

class AccountError extends AccountState {
  final String message;

  AccountError({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() {
    return message;
  }
}
