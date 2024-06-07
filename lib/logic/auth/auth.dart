import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../firebase/firebase.dart';

class Auth {
  final Ref ref;

  late FirebaseAuth _auth;

  Auth(this.ref) {
    _auth = ref.read(firebaseAuthProvider);
  }

  Stream<User?> get authUser {
    late BehaviorSubject<User?> subject;
    subject = BehaviorSubject<User?>(
      onListen: () => _auth.authStateChanges().listen(
            (event) => subject.add(event),
          ),
    );
    return subject.stream;
  }

  User? get currentUser => _auth.currentUser;

  Future get signOut async => _auth.signOut();

  Future get deleteAccount async => _auth.currentUser?.delete();

  Future<UserCredential> get anonymousUser => _auth.signInAnonymously();

  Future updateName(String name) => _auth.currentUser!
      .updateDisplayName(toBeginningOfSentenceCase(name) ?? "");

  Future<UserCredential?> get googleLogin async {
    final AuthCredential? credential = await AuthLoginOption.googleCredentials;
    if (credential == null) return null;
    if (_auth.currentUser == null) {
      return _auth.signInWithCredential(credential);
    }
    return _auth.currentUser?.linkWithCredential(credential);
    //return _auth.signInWithCredential(credential);
  }

  Future<UserCredential?> get appleLogin async {
    //_AuthLoginOption authLoginOption = _AuthLoginOption();
    final AuthCredential credential = await AuthLoginOption.appleLogin;
    return _auth.signInWithCredential(credential);
  }
}

mixin AuthLoginOption {
  static Future<OAuthCredential> get appleLogin async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final String rawNonce = generateNonce();
    final String nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final AuthorizationCredentialAppleID appleCredential =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final OAuthCredential oauthCredential =
        OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    return oauthCredential;
  }

  /// Returns the sha256 hash of [input] in hex notation.
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<AuthCredential?> get googleCredentials async {
    // Trigger the authentication flow
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    try {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      return credential;
    } on PlatformException {
      rethrow;
    }
  }
}
