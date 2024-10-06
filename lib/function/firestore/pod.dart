import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/riddle.dart';
import '../auth/pod.dart';
import 'player.dart';
import 'riddle.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [runningUser])
FirestoreRiddle riddleFirestore(RiddleFirestoreRef ref) {
  final User? user = ref.watch(runningUserProvider).value;
  return FirestoreRiddle(ref, fUser: user);
}

@Riverpod(keepAlive: true, dependencies: [runningUser])
FirestoreUser firestoreUser(FirestoreUserRef ref) {
  final User? user = ref.watch(runningUserProvider).value;
  return FirestoreUser(ref, fUser: user);
}

@Riverpod(keepAlive: true)
Future<Riddle?> riddleDateArg(RiddleDateArgRef ref,
    {required DateTime date}) async {
  final FirestoreRiddle firestoreRiddle = ref.read(riddleFirestoreProvider);
  return firestoreRiddle.riddle(date);
}

@Riverpod(keepAlive: true)
Stream<Riddle> riddleDoc(RiddleDocRef ref, {required DateTime date}) {
  final FirestoreRiddle firestoreRiddle = ref.read(riddleFirestoreProvider);
  return firestoreRiddle.onRiddleModified(date);
}
