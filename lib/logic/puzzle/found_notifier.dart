import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/found.dart';
import '../../model/puzzle.dart';
import '../auth/bloc.dart';
import '../repo/database.dart';
import 'bloc.dart';

part 'found_notifier.g.dart';

@Riverpod(keepAlive: true, dependencies: [authUser, puzzle, datastore])
class FoundNotifier extends _$FoundNotifier {
  final FoundDatabase _db = FoundDatabase();
  late Puzzle puzzle;
  late User? user;

  @override
  Future<Found> build() async {
    puzzle = ref.read(puzzleProvider).value!;
    user = ref.read(authUserProvider).value;

    //
    debugPrint("PuzzleID -> ${puzzle.id}; UserID -> ${user?.uid}");
    Found found = Found(id: puzzle.id);

    if (found.id != null) {
      if (user == null) return found;
      if (kIsWeb) {
        debugPrint("40--Running web");
        return await ref.read(datastoreProvider).found(found.id) ?? found;
      } else {
        final Found? dbFound = await _db.found(found.id!);
        if (dbFound == null) {
          //once check store data
          final Found? storeFound =
              await ref.read(datastoreProvider).found(found.id);
          if (storeFound != null) {
            _db.insertOrder(storeFound);
            return storeFound;
          }
        } else {
          return dbFound;
        }
      }
    }
    return found;
  }

  Future<void> onComplete(String str) async {
    user = user ?? ref.read(authUserProvider).value;
    //
    int index = state.value?.i ?? 1;
    String value = puzzle.words[index].value;

    bool isSame = str == value;
    Found? f = state.value;

    if (f != null) {
      final int fIndex = index + (isSame ? 1 : 0);

      if (fIndex == 6) {
        final Puzzle? p = await ref.refresh(puzzleProvider.future);
        int prev = p?.users.length ?? 0;
        f = f.copyWith(rank: prev + 1);
      }
      f = f.copyWith(
        lastFound: DateTime.now(),
        i: fIndex,
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
          await ref.read(datastoreProvider).updateFound(f);
        } else {
          _db.insertOrder(f);
          await ref.read(datastoreProvider).updateFound(f);
        }
      } else {
        _db.insertOrder(f);
        if (f.i != 1) await ref.read(datastoreProvider).updateFound(f);
      }
    }
  }

  Future delete() => _db.delete();

  @override
  set state(AsyncValue<Found> newState) => super.state = newState;

  incrementHintUsed() async {
    Found? f = state.value;
    f = f?.copyWith(
      lastFound: DateTime.now(),
      hintUsed: (f.hintUsed ?? 0) + 1,
    );
    state = AsyncValue.data(f!);
    ref.read(datastoreProvider).updateFound(f);
  }
}
