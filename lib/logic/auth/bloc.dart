import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth.dart';

part 'bloc.g.dart';

@riverpod
Auth auth(AuthRef ref) => Auth(ref);

@Riverpod(keepAlive: true)
Stream<User?> authUser(AuthUserRef ref) => ref.read(authProvider).authUser;

@riverpod
Future signOut(SignOutRef ref) => ref.read(authProvider).signOut;

@riverpod
Future deleteAccount(DeleteAccountRef ref) =>
    ref.read(authProvider).deleteAccount;

@riverpod
Future<UserCredential> anonymousLogin(AnonymousLoginRef ref) =>
    ref.read(authProvider).anonymousUser;

@riverpod
Future<UserCredential?> googleLogin(GoogleLoginRef ref) =>
    ref.read(authProvider).googleLogin;

@riverpod
Future<UserCredential?> appleLogin(AppleLoginRef ref) =>
    ref.read(authProvider).appleLogin;

@riverpod
Future nameChange(NameChangeRef ref, {required String userName}) async {
  final Auth auth = ref.read(authProvider);
  return auth.updateName(userName);
}

//https://riverpod.dev/docs/concepts/about_code_generation
