import 'package:flutter/foundation.dart';
import 'package:mock_data/mock_data.dart';
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

@Riverpod(keepAlive: true)
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
    ][mockInteger(0, 8)];

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

  Future onComplete(String str) async {
    user = user ?? ref.read(authUserProvider).value;
    //
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
