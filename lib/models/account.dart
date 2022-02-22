import 'package:floor/floor.dart';

@entity
class Account {
  @primaryKey
  final int? id;
  String account;
  String email;
  String password;

  Account({
    this.id,
    required this.account,
    required this.email,
    required this.password,
  });
}
