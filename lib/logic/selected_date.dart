import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/puzzle.dart';
import '../model/found.dart';
import 'cloud/puzzle.dart';
import 'database/local_found.dart';
import 'database/local_puzzle.dart';

part 'selected_date.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
FutureOr<Puzzle?> selectedPuzzle(SelectedPuzzleRef ref, DateTime date) async {
  log("Running selectedPuzzle for ${date.day} - ${date.month}");
  final LocalPuzzle localPuzzle = LocalPuzzle();
  Puzzle? lPuzzle = await localPuzzle.fromDate(date);

  if (lPuzzle == null) {
    final PuzzleCloud puzzleCloud = PuzzleCloud(ref);
    Puzzle? cPuzzle = await puzzleCloud.puzzle(date);

    if (cPuzzle != null) await localPuzzle.insert(cPuzzle);
    return cPuzzle;
  }
  return lPuzzle;
}

@Riverpod(keepAlive: true, dependencies: [selectedPuzzle])
FutureOr<Found?> selectedFound(SelectedFoundRef ref, DateTime date) async {
  log("Running selectedFound for ${date.day} - ${date.month}");
  final Puzzle? puzzle = await ref.read(selectedPuzzleProvider(date).future);

  if (puzzle == null) return null;
  log("33==$puzzle");
  final LocalFound localFound = LocalFound();
  return localFound.found(puzzle.id);
}
