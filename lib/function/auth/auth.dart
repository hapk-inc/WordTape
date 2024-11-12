import 'package:easy_localization/easy_localization.dart';
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

class Auth {
  final Ref ref;

  late FirebaseAuth _auth;
  late Logger tracker;
  late GoogleSignIn _google;

  Auth(this.ref) {
    _auth = ref.read(firebaseAuthProvider);
    tracker = ref.read(trackerProvider);
    final DotEnv dotEnv = ref.read(envProvider);
    final AppEnv appEnv = ref.read(appEnvProvider);
    final bool isDev = appEnv == AppEnv.dev;

    _google = GoogleSignIn(
      clientId: dotEnv.get(
        isDev ? 'CLIENT_ID_DEV' : 'CLIENT_ID_PROD',
        fallback: "CLIENT_ID_PROD".tr(),
      ),
    );
  }

  Stream<User?> get authUser {
    late BehaviorSubject<User?> subject;
    subject = BehaviorSubject<User?>(
      onListen: () => _auth.userChanges().listen(
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

  Future<GoogleSignInAccount?> get googleAuth async {
    final GoogleSignInAccount? account = await _google.signInSilently();
    if (account == null) return _google.signIn();
    return account;
  }

  Stream<GoogleSignInAccount?> get onGoogleUser {
    late BehaviorSubject<GoogleSignInAccount?> subject;
    subject = BehaviorSubject(
      onListen: () => _google.onCurrentUserChanged.listen(
        (GoogleSignInAccount? account) async {
          bool isAuthorized = account != null;
          if (isAuthorized) await _onGoogleAuth(account);
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
    if (_auth.currentUser != null) {
      return _auth.currentUser?.linkWithCredential(credential);
    }
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
