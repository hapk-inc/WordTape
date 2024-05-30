import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/found.dart';

const String _tableName = 'found';

class FoundDatabase {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initializeDatabase;
    return _database!;
  }

  Future<Database> get initializeDatabase async => openDatabase(
        join(await getDatabasesPath(), '$_tableName.db'),
        onCreate: (db, version) {
          return db.execute('CREATE TABLE $_tableName'
              '('
              'id TEXT PRIMARY KEY,'
              'lastFound TEXT,' // date variable
              'rowNo INTEGER,'
              'mistake TEXT'
              ')');
        },
        version: 1,
      );

  //Getting userFound Data
  Future<Found?> found(String id) async {
    if (kIsWeb) return null;
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(_tableName, where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return Found.fromJson(maps.first);

    return null;
  }

  Future insertOrder(Found found) async {
    if (kIsWeb) return;
    final Database db = await database;
    return await db.insert(
      _tableName,
      found.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future delete() async {
    if (kIsWeb) return;
    if (await databaseFactory.databaseExists(await getDatabasesPath())) {
      deleteDatabase(join(await getDatabasesPath(), '$_tableName.db'));
    }
  }
}
