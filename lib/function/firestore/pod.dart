import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/found.dart';
import '../../model/player.dart';
import '../../model/question.dart';
import '../auth/pod.dart';
import 'player.dart';
import 'question.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [runningUser])
FirestoreQuestion firestoreQuestion(Ref ref) {
  final User? user = ref.watch(runningUserProvider).value;
  return FirestoreQuestion(ref, fUser: user);
}

@Riverpod(keepAlive: true, dependencies: [runningUser])
FirestoreUser firestoreUser(Ref<FirestoreUser> ref) {
  final User? user = ref.watch(runningUserProvider).value;
  return FirestoreUser(ref, fUser: user);
}

@Riverpod(keepAlive: true)
Future<Question?> questionWithDate(Ref ref, {required DateTime date}) async {
  final FirestoreQuestion fQuestion = ref.read(firestoreQuestionProvider);
  return fQuestion.question(date);
}

@Riverpod(keepAlive: true)
Stream<Question> onQuestionModified(Ref ref, {required DateTime date}) {
  final FirestoreQuestion fQuestion = ref.read(firestoreQuestionProvider);
  return fQuestion.onQuestionModified(date);
}

@Riverpod(keepAlive: true)
Future<Found?> firestoreFound(Ref ref, {required String id}) {
  final FirestoreQuestion firestoreQuestion =
      ref.read(firestoreQuestionProvider);
  return firestoreQuestion.found(id);
}

@Riverpod(keepAlive: true, dependencies: [firestoreUser])
Stream<Player?> player(Ref ref) {
  final FirestoreUser firestore = ref.read(firestoreUserProvider);
  return firestore.player;
}

@Riverpod(dependencies: [firestoreUser])
Future<void> userFound(Ref ref, {required Found found}) async {
  final FirestoreUser firestore = ref.read(firestoreUserProvider);
  return firestore.userFound(found);
}

@Riverpod(keepAlive: true)
Query<Question> prevQuestionQuery(Ref ref) {
  final FirestoreQuestion firestoreQuestion =
      ref.read(firestoreQuestionProvider);
  return firestoreQuestion.prevQuestion;
}

@Riverpod(keepAlive: true)
ScrollController scrollController(Ref ref) => ScrollController();
