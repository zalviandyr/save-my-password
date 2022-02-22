import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:save_my_password/models/account.dart';
import 'package:save_my_password/services/account_dao.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Account])
abstract class AppDatabase extends FloorDatabase {
  AccountDao get accountDao;
}
