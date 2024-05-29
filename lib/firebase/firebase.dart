import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase.g.dart';

@riverpod
String helloWorld(HelloWorldRef ref) {
  return 'Hello world';
}

@riverpod
FirebaseApp firebaseApp(FirebaseAppRef ref) => throw UnimplementedError();

@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) => throw UnimplementedError();

@riverpod
FirebaseFirestore firebaseFirestore(FirebaseFirestoreRef ref) =>
    throw UnimplementedError();
