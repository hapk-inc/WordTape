import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/puzzle.dart';

//part 'puzzle_database.g.dart';

const String _tableName = 'puzzle';

// selectedDate notifier la potu db initiate panu, so puzzle apidiyae edukalam

//@Riverpod(keepAlive: true, dependencies: [])
//LocalPuzzle puzzleDatabase(PuzzleDatabaseRef ref) => LocalPuzzle();

class LocalPuzzle {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await construct;
    return _database!;
  }

  Future<Database> get construct async {
    return openDatabase(
      join(await getDatabasesPath(), '$_tableName.db'),
      onCreate: (db, version) => db.execute('CREATE TABLE $_tableName'
          '('
          'id TEXT PRIMARY KEY, '
          'date TEXT, '
          'words TEXT, '
          'played INTEGER, '
          'win INTEGER'
          ')'),
      version: 1,
    );
  }

  Future<Puzzle?> fromDate(DateTime dateTime) async {
    if (kIsWeb) return null;
    final Database db = await database;
    final String dateStr = DateFormat('yyyy-MM-dd').format(dateTime);

    final List<Map<String, dynamic>> maps =
        await db.query(_tableName, where: 'date = ?', whereArgs: [dateStr]);
    if (maps.isNotEmpty) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(maps.first);
      map['words'] = jsonDecode(map['words']);
      return Puzzle.fromJson(map);
    }
    return null;
  }

  Future insert(Puzzle puzzle) async {
    if (kIsWeb) return;
    final Database db = await database;
    final Map<String, dynamic> map = puzzle.toJson();
    map['words'] = jsonEncode(map['words']);
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
