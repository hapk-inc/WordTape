import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../../model/found.dart';
import '../../model/puzzle.dart';
import '../auth/auth_notifier.dart';
import '../auth/bloc.dart';
import '../repo/puzzle_datastore.dart';
import '../repo/word_analytics.dart';

part 'bloc.g.dart';

@Riverpod(keepAlive: true, dependencies: [authUser])
WordAnalytics wordAnalytics(WordAnalyticsRef ref) {
  final User? user = ref.watch(authUserProvider).value;
  return WordAnalytics(ref, fUser: user);
}

@Riverpod(keepAlive: true, dependencies: [authUser, puzzle, datastore])
Future<Found?> selectedFound(SelectedFoundRef ref) async {
  final User? user = ref.watch(authUserProvider).value;

  if (user == null) return null;
  final Puzzle? puzzle = ref.watch(puzzleProvider).value;

  final Found? found = await ref.read(datastoreProvider).found(puzzle?.id);

  return found;
}

/*@Riverpod(keepAlive: true,dependencies: [datastore,puzzle])
Stream<int> foundCount(FoundCountRef ref) yield{
  final Puzzle? puzzle = ref.watch(puzzleProvider).value;
  if(puzzle ==null) return;
  return ref.read(datastoreProvider).foundCount(puzzle?.id!);
}*/

@Riverpod(keepAlive: true, dependencies: [datastore])
Future<Puzzle?> puzzle(PuzzleRef ref) async {
  final AuthNotifier app = ref.watch(authNotifierProvider);
  return ref.read(datastoreProvider).puzzle(app.dateTime);
}

@Riverpod(keepAlive: true, dependencies: [authUser])
PuzzleDatastore datastore(DatastoreRef ref) {
  final User? user = ref.watch(authUserProvider).value;
  return PuzzleDatastore(ref, fUser: user);
}

@Riverpod(keepAlive: true)
Future<int> foundCount(FoundCountRef ref) async {
  final Puzzle? puzzle = ref.watch(puzzleProvider).value;
  if (puzzle == null) return 0;
  return ref.read(datastoreProvider).foundCount(puzzle.id);
}

///
