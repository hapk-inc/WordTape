import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/puzzle.dart';

part 'puzzle_notifier.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
class PuzzleNotifier extends _$PuzzleNotifier {
  @override
  Puzzle build(String id) => Puzzle.fromRandom();
}
