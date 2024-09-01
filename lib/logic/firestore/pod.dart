import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/puzzle.dart';
import 'puzzle_cloud.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
PuzzleCloud puzzleCloud(PuzzleCloudRef ref) => PuzzleCloud(ref);

@Riverpod(dependencies: [puzzleCloud])
Future<Puzzle?> puzzleFromDate(PuzzleFromDateRef ref,
    {required DateTime date}) async {
  final PuzzleCloud pc = ref.read(puzzleCloudProvider);
  return pc.puzzle(date);
}
