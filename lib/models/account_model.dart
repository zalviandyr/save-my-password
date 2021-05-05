import 'package:equatable/equatable.dart';

class AccountModel extends Equatable {
  final int id;
  final String account;
  final String username;
  final String password;

  AccountModel({
    this.id = 0,
    required this.account,
    required this.username,
    required this.password,
  });

  static List<AccountModel> fromMaps(List<Map> maps) {
    List<AccountModel> accountModels = [];

    for (Map map in maps) {
      accountModels.add(AccountModel(
        id: map['id'],
        account: map['account'],
        username: map['username'],
        password: map['password'],
      ));
    }

    return accountModels;
  }

  @override
  String toString() {
    return '$id - $account - $username - $password';
  }

  @override
  List<Object?> get props => [account];
}
