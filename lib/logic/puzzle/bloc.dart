import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:firebase_auth/firebase_auth.dart';
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
  late Puzzle puzzle;
  late User? user;

  @override
  Future<Found?> build() async {
    puzzle = ref.read(puzzleProvider).value!;
    debugPrint("32--$puzzle");
    if (puzzle.id == null) return null;
    final String id = puzzle.id!;
    Found f = const Found().copyWith(id: id);
    debugPrint("36--${f.id}");
    user = ref.read(authUserProvider).value;
    debugPrint("38--$user");
    debugPrint("38--${ref.read(appNotifierProvider).authValidate}");
    if (user == null) return f;
    if (kIsWeb) {
      debugPrint("40--");
      f = await ref.read(datastoreProvider).found(id) ?? f;
    } else {
      f = await _db.found(id) ?? f;
    }
    return f;
  }

  Future delete() => _db.delete();

  Future onComplete(String str) async {
    int index = state.value?.i ?? 1;
    String value = puzzle.words[index].value;

    if (str == value) {
      debugPrint("54--$user");
      if (user == null) ref.read(anonymousLoginProvider);
      final Found f = state.value!.copyWith(
        i: index + 1,
        mistake: null,
        lastFound: DateTime.now(),
      );
      if (kIsWeb) {
        await ref.read(datastoreProvider).updateFound(f);
      } else {
        await _db.insertOrder(f);
      }
    } else {
      final Found f = state.value!.copyWith(
        mistake: str,
        lastFound: DateTime.now(),
      );
      await _db.insertOrder(f);
    }
  }
}
