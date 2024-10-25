import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:games_services/games_services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

import '../../enum/enum.dart';
import '../../firebase/pod.dart';

//const List<String> _scopes = <String>['email'];

class Auth {
  final Ref ref;

  late FirebaseAuth _auth;
  late Logger tracker;
  late GoogleSignIn _googleSignIn;

  Auth(this.ref) {
    _auth = ref.read(firebaseAuthProvider);
    tracker = ref.read(trackerProvider);
    final DotEnv dotEnv = ref.read(envProvider);
    final AppEnv appEnv = ref.read(appEnvProvider);

    _googleSignIn = GoogleSignIn(
        clientId: dotEnv.get(
      appEnv == AppEnv.dev ? 'CLIENT_ID_DEV' : 'CLIENT_ID_PROD',
    ));
  }

  Stream<User?> get authUser {
    late BehaviorSubject<User?> subject;
    subject = BehaviorSubject<User?>(
      onListen: () => _auth.authStateChanges().listen(
        (event) {
          if (!subject.hasValue || subject.value != event) {
            tracker.d(event == null ? "No User" : event.displayName);
            subject.add(event);
          }
        },
      ),
    );
    return subject.stream;
  }

  Future<User?> get fUser async => _auth.currentUser;

  Future get googleAuth async => _googleSignIn.signInSilently();

  Stream<User?> get onGoogleUser {
    late BehaviorSubject<User?> subject;
    subject = BehaviorSubject(
      onListen: () => _googleSignIn.onCurrentUserChanged.listen(
        (GoogleSignInAccount? account) async {
          bool isAuthorized = account != null;
          if (isAuthorized) await _onGoogleAuth(account);
        },
        onError: (e, s) {
          tracker.e("onGoogleUser", error: e, stackTrace: s);
        },
      ),
    );
    return subject.stream;
  }

  Future<UserCredential?> _onGoogleAuth(GoogleSignInAccount account) async {
    final GoogleSignInAuthentication googleAuth = await account.authentication;

    // Create a new credential
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<bool> get userLogin async {
    if (kIsWeb) {
      await _auth.signInAnonymously();
      return true;
    } else {
      if (!await GamesServices.isSignedIn && !kIsWeb) {
        final String? str = await GamesServices.signIn();
        tracker.d(str);
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
