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

@Riverpod(keepAlive: true, dependencies: [authUser])
Datastore datastore(DatastoreRef ref) {
  final User? user = ref.watch(authUserProvider).value;
  debugPrint("16--New User==$user");
  return Datastore(ref, fUser: user);
}

@Riverpod(keepAlive: true, dependencies: [datastore])
Future<Puzzle?> puzzle(PuzzleRef ref) async {
  final AppNotifier app = ref.watch(appNotifierProvider);
  return ref.read(datastoreProvider).puzzle(app.dateTime);
}

///

@Riverpod(keepAlive: true, dependencies: [firebaseUser, puzzle, datastore])
class FoundNotifier extends _$FoundNotifier {
  final FoundDatabase _db = FoundDatabase();
  late Puzzle puzzle;
  late User? user;

  @override
  FutureOr<Found?> build() async {
    puzzle = ref.read(puzzleProvider).value!;
    user = ref.watch(firebaseUserProvider);

    //
    debugPrint("PuzzleID -> ${puzzle.id}; UserID -> ${user?.uid}");
    Found found = Found(id: puzzle.id);

    if (found.id != null) {
      if (user == null) return found;
      if (kIsWeb) {
        debugPrint("40--Running web");
        return ref.read(datastoreProvider).found(found.id!);
      } else {
        return _db.found(found.id!);
      }
    }
    return found;
  }

  Future onComplete(String str) async {
    user = ref.read(firebaseUserProvider);
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
              user = value.user;
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
