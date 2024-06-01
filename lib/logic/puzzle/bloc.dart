import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../../model/found.dart';
import '../../model/puzzle.dart';
import '../app/app_notifier.dart';
import '../auth/bloc.dart';
import '../repo/database.dart';
import '../repo/datastore.dart';

part 'bloc.g.dart';

@Riverpod(keepAlive: true, dependencies: [authUser])
Datastore datastore(DatastoreRef ref) {
  final User? user = ref.watch(authUserProvider).value;
  return Datastore(ref, fUser: user);
}

@Riverpod(keepAlive: true, dependencies: [authUser, puzzle, datastore])
Future<Found?> selectedFound(SelectedFoundRef ref) async {
  final User? user = ref.read(authUserProvider).value;
  if (user == null) return null;
  final Puzzle? puzzle = ref.watch(puzzleProvider).value;
  final Found? found = await ref.read(datastoreProvider).found(puzzle?.id);
  return found;
}

@Riverpod(keepAlive: true, dependencies: [datastore])
Future<Puzzle?> puzzle(PuzzleRef ref) async {
  final AppNotifier app = ref.watch(appNotifierProvider);
  return ref.read(datastoreProvider).puzzle(app.dateTime);
}

///

@Riverpod(keepAlive: true, dependencies: [authUser, puzzle, datastore])
class FoundNotifier extends _$FoundNotifier {
  final FoundDatabase _db = FoundDatabase();
  late Puzzle puzzle;
  late User? user;

  @override
  FutureOr<Found?> build() async {
    puzzle = ref.read(puzzleProvider).value!;
    user = ref.read(authUserProvider).value;

    //
    debugPrint("PuzzleID -> ${puzzle.id}; UserID -> ${user?.uid}");
    Found found = Found(id: puzzle.id);

    if (found.id != null) {
      if (user == null) return found;
      if (kIsWeb) {
        debugPrint("40--Running web");
        return ref.read(datastoreProvider).found(found.id);
      } else {
        //
        return await _db.found(found.id!) ??
            await ref.read(datastoreProvider).found(found.id);
      }
    }
    return found;
  }

  Future onComplete(String str) async {
    user = user ?? ref.read(authUserProvider).value;
    debugPrint("OnComplete User--${user?.uid}");
    int index = state.value?.i ?? 1;
    String value = puzzle.words[index].value;

    bool isSame = str == value;
    Found? f = state.value;
    if (f != null) {
      f = f.copyWith(
        lastFound: DateTime.now(),
        i: index + (isSame ? 1 : 0),
        mistake: isSame ? null : str,
      );
      state = AsyncValue.data(f);
      if (isSame) {
        if (user == null) {
          await ref.read(anonymousLoginProvider.future).then(
            (value) {
              ref.read(datastoreProvider).createUser;
            },
          );
        }

        if (kIsWeb) {
          debugPrint("69--$f");
          await ref.read(datastoreProvider).updateFound(f);
        } else {
          _db.insertOrder(f);
          await ref.read(datastoreProvider).updateFound(f);
        }
      } else {
        _db.insertOrder(f);
        await ref.read(datastoreProvider).updateFound(f);
      }
    }
  }

  Future delete() => _db.delete();

  @override
  set state(AsyncValue<Found?> newState) => super.state = newState;
}
