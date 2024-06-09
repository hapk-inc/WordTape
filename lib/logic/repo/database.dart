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
              'i INTEGER,'
              'mistake TEXT'
              ')');
        },
        version: 1,
      );

  //Getting userFound Data
  Future<Found?> found(String id) async {
    debugPrint("Running FoundDB found $id");
    if (kIsWeb) return null;
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(_tableName, where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return Found.fromJson(maps.first);

    return null;
  }

  Future insertOrder(Found found) async {
    debugPrint("insertFound $found");
    if (kIsWeb) return;
    final Database db = await database;
    final Map<String, dynamic> map = found.toJson();
    if (map.containsKey('rank')) map.remove('rank');
    if (map.containsKey('hintUsed')) map.remove('hintUsed');
    if (map.containsKey('revealed')) map.remove('revealed');
    return await db.insert(
      _tableName,
      map,
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
