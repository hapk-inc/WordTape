import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/puzzle.dart';

part 'selected_puzzle.g.dart';

/*
@Riverpod(keepAlive: true, dependencies: [])
class PuzzleNotifier extends _$PuzzleNotifier {
  @override
  Puzzle build(String id) => Puzzle.fromRandom();
}
*/

/*@riverpod
class SelectedPuzzle extends _$SelectedPuzzle {
  @override
  Puzzle build(String id) => Puzzle.fromRandom();
}*/

@riverpod
class SelectedPuzzle extends _$SelectedPuzzle {
  @override
  FutureOr<Puzzle> build(String id) async => Puzzle.fromRandom();
}
