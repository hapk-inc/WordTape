import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/found.dart';
import '../../model/puzzle.dart';
import '../app/dashboard_notifier.dart';
import '../auth/bloc.dart';
import '../repo/database.dart';
import '../repo/datastore.dart';

part 'bloc.g.dart';

@Riverpod(keepAlive: true)
Datastore datastore(DatastoreRef ref) => Datastore(ref);

@Riverpod(dependencies: [datastore])
Future<Puzzle?> puzzle(PuzzleRef ref) async {
  final AppNotifier app = ref.watch(appNotifierProvider);
  return ref.read(datastoreProvider).puzzle(app.dateTime);
}

@Riverpod(dependencies: [authUser, puzzle])
class FoundNotifier extends _$FoundNotifier {
  final FoundDatabase _db = FoundDatabase();

  @override
  Future<Found?> build() async {
    final Puzzle puzzle = ref.read(puzzleProvider).value!;
    if (puzzle.id == null) return null;
    final String id = puzzle.id!;
    Found f = const Found().copyWith(id: id);
    if (ref.watch(authUserProvider).value == null) return f;
    if (kIsWeb) {
      return f;
    } else {
      f = await _db.found(id) ?? f;
    }
    return f;
  }
}

/*@Riverpod(dependencies: [puzzle])
Future<Found?> found(FoundRef ref) async {
  final Puzzle? puzzle = ref.watch(puzzleProvider).value;
  final AppNotifier app = ref.watch(appNotifierProvider);
  if (app.notLogged) return null;
  return const Found();
}*/
