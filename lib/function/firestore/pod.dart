import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/riddle.dart';
import '../auth/pod.dart';
import 'riddle.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [runningUser])
FirestoreRiddle riddleFirestore(RiddleFirestoreRef ref) {
  final User? user = ref.watch(runningUserProvider).value;
  return FirestoreRiddle(ref, fUser: user);
}

@Riverpod(keepAlive: true)
Future<Riddle?> riddleDateArg(RiddleDateArgRef ref,
    {required DateTime date}) async {
  final FirestoreRiddle firestoreRiddle = ref.read(riddleFirestoreProvider);
  return firestoreRiddle.riddle(date);
}
