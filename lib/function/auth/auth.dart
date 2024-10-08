import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:games_services/games_services.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

import '../../firebase/pod.dart';
import '../../logger/log.dart';

class Auth {
  final Ref ref;

  late FirebaseAuth _auth;
  late Logger log;

  Auth(this.ref) {
    _auth = ref.read(firebaseAuthProvider);
    log = ref.read(logProvider);
  }

  Stream<User?> get authUser {
    late BehaviorSubject<User?> subject;
    subject = BehaviorSubject<User?>(
      onListen: () => _auth.authStateChanges().listen(
        (event) {
          if (!subject.hasValue || subject.value != event) {
            log.d(event?.uid ?? "No ID");
            log.d(event?.displayName ?? "No Name");
            subject.add(event);
          }
        },
      ),
    );
    return subject.stream;
  }

  Future<User?> get fUser async => _auth.currentUser;

  Future<bool> get userLogin async {
    if (kIsWeb) {
      await _auth.signInAnonymously();
      return true;
    } else {
      if (!await GamesServices.isSignedIn && !kIsWeb) {
        final String? str = await GamesServices.signIn();
        log.d(str);
      }

      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          {
            final OAuthCredential credential =
                PlayGamesAuthProvider.credential(serverAuthCode: '');
            await _auth.signInWithCredential(credential);
            return true;
          }

        case TargetPlatform.iOS:
          {
            final OAuthCredential credential =
                GameCenterAuthProvider.credential();
            await _auth.signInWithCredential(credential);
            return true;
          }

        case TargetPlatform.macOS:
          {
            final OAuthCredential credential =
                GameCenterAuthProvider.credential();
            await _auth.signInWithCredential(credential);
            return true;
          }
        default:
          {
            await _auth.signInAnonymously();
            return true;
          }
      }
    }
  }

  Future get logOff => _auth.signOut();
}
