import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/riddle.dart';

const String _tableName = 'Riddle';

class LocalRiddle {
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
          'id TEXT PRIMARY KEY, '
          'date TEXT, words TEXT, '
          'played INTEGER, win INTEGER'
          ')',
        ),
        version: 1,
      );

  Future<Riddle?> get latest async {
    if (kIsWeb) return null;
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'date DESC',
    );

    //
    if (maps.isEmpty) return null;
    final Map<String, dynamic> map = Map<String, dynamic>.from(maps.first);
    // map['words'] = jsonDecode(map['words']);
    return Riddle.fromJson(map);
  }

  Future<Riddle?> fromDate(DateTime dateTime) async {
    if (kIsWeb) return null;
    final Database db = await database;
    final String dateStr = DateFormat('yyyy-MM-dd').format(dateTime);

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'date = ?',
      whereArgs: [dateStr],
    );

    if (maps.isEmpty) return null;
    final Map<String, dynamic> map = Map<String, dynamic>.from(maps.first);
    return Riddle.fromJson(map);
  }

  Future insert(Riddle puzzle) async {
    if (kIsWeb) return;
    final Database db = await database;
    final Map<String, dynamic> map = puzzle.toJson();
    return await db.insert(
      _tableName,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete() async {
    if (kIsWeb) return;
    if (await databaseFactory.databaseExists(await getDatabasesPath())) {
      deleteDatabase(join(await getDatabasesPath(), '$_tableName.db'));
    }
  }
}
