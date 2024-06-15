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
PuzzleDatastore datastore(DatastoreRef ref) {
  final User? user = ref.watch(authUserProvider).value;
  return PuzzleDatastore(ref, fUser: user);
}

@Riverpod(keepAlive: true, dependencies: [authUser])
WordAnalytics wordAnalytics(WordAnalyticsRef ref) {
  final User? user = ref.watch(authUserProvider).value;
  return WordAnalytics(ref, fUser: user);
}

/*@Riverpod(keepAlive: true)
String excellent(ExcellentRef ref) => [
      "Well done on solving today's puzzle!",
      "Excellent work on the puzzle today!",
      "You did a fantastic job with today's puzzle!",
      "Congrats on completing today's puzzle!",
      "Impressive work on today's puzzle!",
      "Great effort on the puzzle for today!",
      "Kudos on today's puzzle success!",
      "You nailed today's puzzle!",
      "Outstanding job with today's puzzle!",
      // "Bravo on solving today's puzzle!"
    ][mockInteger(0, 8)];*/

@Riverpod(keepAlive: true, dependencies: [authUser, puzzle, datastore])
Future<Found?> selectedFound(SelectedFoundRef ref) async {
  final User? user = ref.watch(authUserProvider).value;

  if (user == null) return null;
  final Puzzle? puzzle = ref.watch(puzzleProvider).value;

  final Found? found = await ref.read(datastoreProvider).found(puzzle?.id);

  return found;
}

@Riverpod(keepAlive: true, dependencies: [datastore])
Future<Puzzle?> puzzle(PuzzleRef ref) async {
  final AuthNotifier app = ref.watch(authNotifierProvider);
  return ref.read(datastoreProvider).puzzle(app.dateTime);
}

///
