// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AccountDao? _accountDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Account` (`id` INTEGER, `account` TEXT NOT NULL, `email` TEXT NOT NULL, `password` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AccountDao get accountDao {
    return _accountDaoInstance ??= _$AccountDao(database, changeListener);
  }
}

class _$AccountDao extends AccountDao {
  _$AccountDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _accountInsertionAdapter = InsertionAdapter(
            database,
            'Account',
            (Account item) => <String, Object?>{
                  'id': item.id,
                  'account': item.account,
                  'email': item.email,
                  'password': item.password
                }),
        _accountUpdateAdapter = UpdateAdapter(
            database,
            'Account',
            ['id'],
            (Account item) => <String, Object?>{
                  'id': item.id,
                  'account': item.account,
                  'email': item.email,
                  'password': item.password
                }),
        _accountDeletionAdapter = DeletionAdapter(
            database,
            'Account',
            ['id'],
            (Account item) => <String, Object?>{
                  'id': item.id,
                  'account': item.account,
                  'email': item.email,
                  'password': item.password
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Account> _accountInsertionAdapter;

  final UpdateAdapter<Account> _accountUpdateAdapter;

  final DeletionAdapter<Account> _accountDeletionAdapter;

  @override
  Future<List<Account>> findAllAccount() async {
    return _queryAdapter.queryList('SELECT * FROM Account',
        mapper: (Map<String, Object?> row) => Account(
            id: row['id'] as int?,
            account: row['account'] as String,
            email: row['email'] as String,
            password: row['password'] as String));
  }

  @override
  Future<void> insertAccount(Account account) async {
    await _accountInsertionAdapter.insert(account, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateAccount(Account account) async {
    await _accountUpdateAdapter.update(account, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteAccount(Account account) async {
    await _accountDeletionAdapter.delete(account);
  }
}
