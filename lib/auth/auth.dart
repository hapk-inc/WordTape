import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:games_services/games_services.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../firebase/firebase.dart';
import '../log/logger.dart';

part 'auth.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
Auth auth(AuthRef ref) => Auth(ref);

class Auth {
  final Ref ref;

  late FirebaseAuth _auth;
  late Logger logger;

  Auth(this.ref) {
    _auth = ref.read(firebaseAuthProvider);
    logger = ref.read(logProvider);
  }

  Stream<User?> get authUser {
    late BehaviorSubject<User?> subject;
    subject = BehaviorSubject<User?>(
      onListen: () => _auth.authStateChanges().listen(
        (event) {
          logger.d("$event");
          if (!subject.hasValue) {
            subject.add(event);
          } else if (subject.value != event) {
            subject.add(event);
          }
        },
      ),
    );
    return subject.stream;
  }

  Future<bool> get userLogin async {
    if (!await GamesServices.isSignedIn) {
      final String? str = await GamesServices.signIn();
      logger.d(str);
    } else {
      final credential = GameCenterAuthProvider.credential();
      logger.d(credential);
      _auth.signInWithCredential(credential);
    }

    return false;
  }
}
