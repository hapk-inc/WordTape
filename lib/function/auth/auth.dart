import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:games_services/games_services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

import '../../firebase/pod.dart';
import '../../logger/log.dart';

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

class Auth {
  final Ref ref;

  late FirebaseAuth _auth;
  late Logger log;
  late GoogleSignIn _googleSignIn;

  Auth(this.ref) {
    _auth = ref.read(firebaseAuthProvider);
    log = ref.read(logProvider);
    _googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
      clientId:
          "784902004586-12flsv1ai4cui16do9ad8ucvm5027eiv.apps.googleusercontent.com",
    );
  }

  Stream<User?> get authUser {
    late BehaviorSubject<User?> subject;
    subject = BehaviorSubject<User?>(
      onListen: () => _auth.authStateChanges().listen(
        (event) {
          if (!subject.hasValue || subject.value != event) {
            log.d(event == null ? "No User" : event.displayName);
            subject.add(event);
          }
        },
      ),
    );
    return subject.stream;
  }

  Future<User?> get fUser async => _auth.currentUser;

  Future get googleAuth async => _googleSignIn.signInSilently();

  Stream<User?> onGoogleUser() {
    late BehaviorSubject<User?> subject;
    subject = BehaviorSubject(
      onListen: () => _googleSignIn.onCurrentUserChanged.listen(
        (GoogleSignInAccount? account) async {
          print("60==");
          // In mobile, being authenticated means being authorized...
          bool isAuthorized = account != null;
          // However, on web...
          if (kIsWeb && isAuthorized) {
            isAuthorized = await _googleSignIn.canAccessScopes(scopes);
          }

          if (isAuthorized) {
            print("75==");
          }
        },
      ),
    );
    return subject.stream;
  }
/*
  Future<UserCredential?> get googleAuth async {
    final GoogleSignInAccount? google = await GoogleSignIn(scopes: scopes)
        .signInSilently(reAuthenticate: true)
        .then(
      (GoogleSignInAccount? value) {
        print("50==$value");
        return value;
      },
    ).catchError(
      (error, stackTrace) {
        log.e("45==", error: error);
        return null;
      },
    );
    try {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await google!.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return _auth.signInWithCredential(credential);
    } catch (e, s) {
      ref.read(logProvider).e("error", error: e, stackTrace: s);
      rethrow;
    } */
/*on PlatformException {
      ref.read(logProvider).e(GoogleSignIn.kSignInFailedError);
      rethrow;
    }*/ /*

  }
*/

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
