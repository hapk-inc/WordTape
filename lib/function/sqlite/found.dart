import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/found.dart';

const String _tableName = 'found';

class LocalFound {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await construct;
    return _database!;
  }

  Future<Database> get construct async => openDatabase(
        join(await getDatabasesPath(), '$_tableName.db'),
        onCreate: (db, version) => db.execute(
          'CREATE TABLE $_tableName'
          '('
          'id TEXT PRIMARY KEY,'
          'lastFound TEXT, date TEXT,' // date variable
          'i INTEGER,'
          'mistake TEXT, soFar TEXT'
          ')',
        ),
        version: 1,
      );

  //Getting userFound Data
  Future<Found?> found(String? id) async {
    if (kIsWeb) return null;
    if (id == null) return null;
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) return Found.fromJson(maps.first);
    return null;
  }

  Future insert(Found found) async {
    if (kIsWeb) return;
    if (await databaseFactory.databaseExists(await getDatabasesPath())) {
      final Database db = await database;
      final Map<String, dynamic> map = found.toJson();

      return await db.insert(
        _tableName,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future delete() async {
    if (kIsWeb) return;
    if (await databaseFactory.databaseExists(await getDatabasesPath())) {
      deleteDatabase(join(await getDatabasesPath(), '$_tableName.db'));
    }
  }
}
