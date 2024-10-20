import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/found.dart';
import '../../model/player.dart';
import '../../model/question.dart';
import '../auth/pod.dart';
import 'player.dart';
import 'question.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [runningUser])
FirestoreQuestion firestoreQuestion(FirestoreQuestionRef ref) {
  final User? user = ref.watch(runningUserProvider).value;
  return FirestoreQuestion(ref, fUser: user);
}

@Riverpod(keepAlive: true, dependencies: [runningUser])
FirestoreUser firestoreUser(FirestoreUserRef ref) {
  final User? user = ref.watch(runningUserProvider).value;
  return FirestoreUser(ref, fUser: user);
}

@Riverpod(keepAlive: true)
Future<Question?> questionWithDate(QuestionWithDateRef ref,
    {required DateTime date}) async {
  final FirestoreQuestion firestoreQuestion =
      ref.read(firestoreQuestionProvider);
  return firestoreQuestion.question(date);
}

@Riverpod(keepAlive: true)
Stream<Question> onQuestionModified(OnQuestionModifiedRef ref,
    {required DateTime date}) {
  final FirestoreQuestion firestoreQuestion =
      ref.read(firestoreQuestionProvider);
  return firestoreQuestion.onQuestionModified(date);
}

@Riverpod(keepAlive: true)
Future<Found?> firestoreFound(FirestoreFoundRef ref, {required String id}) {
  final FirestoreQuestion firestoreQuestion =
      ref.read(firestoreQuestionProvider);
  return firestoreQuestion.found(id);
}

@Riverpod(keepAlive: true, dependencies: [firestoreUser])
Stream<Player?> player(PlayerRef ref) {
  final FirestoreUser firestore = ref.read(firestoreUserProvider);
  return firestore.player;
}

@Riverpod(dependencies: [firestoreUser])
Future<void> userFound(UserFoundRef ref, {required Found found}) async {
  final FirestoreUser firestore = ref.read(firestoreUserProvider);
  return firestore.userFound(found);
}
