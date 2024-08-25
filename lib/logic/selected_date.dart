import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/found.dart';
import '../model/puzzle.dart';
import 'cloud/puzzle.dart';
import 'database/local_found.dart';
import 'database/local_puzzle.dart';

final ChangeNotifierProvider<SelectedDateNotifier>
    selectedDateNotifierProvider = ChangeNotifierProvider<SelectedDateNotifier>(
  (ref) => SelectedDateNotifier(ref)..constructPuzzle,
);

class SelectedDateNotifier extends ChangeNotifier {
  DateTime _date = DateTime.now();
  Puzzle? _puzzle;
  Found? _found;

  //
  final Ref ref;

  final LocalPuzzle localPuzzle = LocalPuzzle();
  final LocalFound localFound = LocalFound();
  late PuzzleCloud puzzleCloud;

  SelectedDateNotifier(this.ref) {
    puzzleCloud = PuzzleCloud(ref);
  }

  Future<void> get constructPuzzle async {
    Puzzle? lPuzzle = await localPuzzle.fromDate(_date);
    if (lPuzzle == null) {
      Puzzle cPuzzle = await puzzleCloud.puzzle(_date) ?? Puzzle.fromRandom();
      await localPuzzle.insert(cPuzzle);
      _puzzle = cPuzzle;
    } else {
      _puzzle = lPuzzle;
    }
    _found = await localFound.found(_puzzle?.id) ?? const Found();
  }

  Puzzle get puzzle => _puzzle ?? Puzzle.fromRandom();

  set date(DateTime value) {
    if (_date == value) return;
    _date = value;
    notifyListeners();
  }

  DateTime get date => _date;

  Future<void> deleteDatabase() async {
    await localFound.delete();
    return localPuzzle.delete();
  }

  Found get found => _found ?? const Found();

  set found(Found value) {
    if (_found == value) return;
    _found = value;
    notifyListeners();
  }
}
