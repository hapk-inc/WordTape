import 'package:firebase_auth/firebase_auth.dart';
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

@Riverpod(keepAlive: true, dependencies: [authUser, puzzle])
class FoundNotifier extends _$FoundNotifier {
  final FoundDatabase _db = FoundDatabase();

  @override
  Future<Found?> build() async {
    final Puzzle puzzle = ref.read(puzzleProvider).value!;
    if (puzzle.id == null) return null;
    final String id = puzzle.id!;
    Found f = const Found().copyWith(id: id);
    if (ref.read(authUserProvider).value == null) return f;
    if (kIsWeb) {
      return f;
    } else {
      f = await _db.found(id) ?? f;
    }
    return f;
  }

  Future get changeFound async {
    final User? user = ref.read(authUserProvider).value;
    if (user == null) await ref.read(anonymousLoginProvider.future);
    if (kIsWeb) {
    } else {
      Found found = state.value!;
      found = found.copyWith(rowNo: found.rowNo + 1, lastFound: DateTime.now());

      await _db.insertOrder(found);
    }
  }

  newMistake(String s) {}

  Future delete() => _db.delete();
}
