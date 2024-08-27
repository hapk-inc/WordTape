import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../firebase/firebase.dart';

class Auth {
  final Ref ref;

  late FirebaseAuth _auth;

  Auth(this.ref) {
    _auth = ref.read(firebaseAuthProvider);
  }

  Stream<User?> get authUser {
    late BehaviorSubject<User?> subject;
    subject = BehaviorSubject<User?>(
      onListen: () =>
          _auth.authStateChanges().listen((event) => subject.add(event)),
    );
    return subject.stream;
  }

  User? get currentUser => _auth.currentUser;

  Future get signOut async => _auth.signOut();

  Future get deleteAccount async => _auth.currentUser?.delete();

  Future<UserCredential> get anonymousUser => _auth.signInAnonymously();

  Future updateName(String name) => _auth.currentUser!
      .updateDisplayName(toBeginningOfSentenceCase(name) ?? "");

  /*Future gameCenterAuth() async {
    final a = await GamesServices.signIn();
  }*/
}
