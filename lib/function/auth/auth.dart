import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:games_services/games_services.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

import '../../firebase/pod.dart';
import '../logger/pod.dart';

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
          if (!subject.hasValue || subject.value != event) {
            logger.d("$event");
            subject.add(event);
          }
        },
      ),
    );
    return subject.stream;
  }

  Future<User?> get fUser async => _auth.currentUser;

  Future<bool> get userLogin async {
    if (!await GamesServices.isSignedIn) {
      final String? str = await GamesServices.signIn();
      logger.d(str);
    }
    late OAuthCredential credential;
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      credential = GameCenterAuthProvider.credential();
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      credential = PlayGamesAuthProvider.credential(serverAuthCode: '');
    } else {
      return false;
    }
    await _auth.signInWithCredential(credential);
    return true;
  }

  Future get logOff => _auth.signOut();
}
