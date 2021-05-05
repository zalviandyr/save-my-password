import 'package:path_provider/path_provider.dart';
import 'package:save_my_password/models/account_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AccountService {
  final String table = 'accounts';
  late String _dbName;
  late String _dbPath;
  Database? db;

  Future<void> init() async {
    sqfliteFfiInit();

    _dbName = 'save_my_password.db';
    _dbPath = (await getTemporaryDirectory()).path + '\\' + _dbName;
    db = await databaseFactoryFfi.openDatabase(_dbPath);

    String createTable = '''CREATE TABLE IF NOT EXISTS $table
        (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          account TEXT,
          username TEXT,
          password TEXT
        )
        ''';

    await db!.execute(createTable);
  }

  Future<void> insert(AccountModel accountModel) async {
    await db!.insert(table, {
      'account': accountModel.account,
      'username': accountModel.username,
      'password': accountModel.password,
    });
  }

  Future<void> batchInsert(List<AccountModel> accountModels) async {
    await db!.transaction((txn) async {
      for (AccountModel accountModel in accountModels) {
        await txn.rawInsert(
          'INSERT INTO $table(account, username, password) VALUES(?, ?, ?)',
          [
            accountModel.account,
            accountModel.username,
            accountModel.password,
          ],
        );
      }
    });
  }

  Future<List<AccountModel>> getsData() async {
    List<Map> results = await db!.query(
      table,
      columns: ['id', 'account', 'username', 'password'],
      orderBy: 'account',
    );

    return AccountModel.fromMaps(results);
  }

  Future<List<AccountModel>> getData(String accountFilter) async {
    List<Map> results = await db!.query(
      table,
      columns: ['id', 'account', 'username', 'password'],
      where: 'account = ?',
      whereArgs: [accountFilter],
      orderBy: 'account',
    );

    return AccountModel.fromMaps(results);
  }

  Future<void> update(AccountModel accountModel) async {
    await db!.update(
      table,
      {
        'account': accountModel.account,
        'username': accountModel.username,
        'password': accountModel.password,
      },
      where: 'id = ?',
      whereArgs: [accountModel.id],
    );
  }

  Future<void> delete(AccountModel accountModel) async {
    await db!.delete(table, where: 'id = ?', whereArgs: [accountModel.id]);
  }
}
