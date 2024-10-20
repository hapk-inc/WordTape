import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/question.dart';

const String _tableName = 'Question';

class LocalQuestion {
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

  Future<Question?> get latest async {
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
    return Question.fromJson(map);
  }

  Future<Question?> fromDate(DateTime dateTime) async {
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
    map.update(
      "words",
      (value) {
        final list = jsonDecode(value) as List;
        return list;
      },
    );
    return Question.fromJsonJson(map);
  }

  Future insert(Question question) async {
    if (kIsWeb) return;
    final Database db = await database;
    final Map<String, dynamic> map = question.toJson();
    map.update("words", (value) => jsonEncode(value));

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
