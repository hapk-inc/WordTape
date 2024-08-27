import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

//import '../../model/player.dart';
//import '../repo/user_datastore.dart';
import 'auth.dart';

part 'bloc.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
Auth auth(AuthRef ref) => Auth(ref);

@Riverpod(keepAlive: true, dependencies: [auth])
Stream<User?> authUser(AuthUserRef ref) => ref.read(authProvider).authUser;

@Riverpod(dependencies: [auth])
Future signOut(SignOutRef ref) async {
  final Auth auth = ref.read(authProvider);
  await auth.signOut;
  return auth.deleteAccount;
}

@Riverpod(keepAlive: true, dependencies: [auth])
User? firebaseUser(FirebaseUserRef ref) => ref.read(authProvider).currentUser;

@Riverpod(dependencies: [auth])
Future deleteAccount(DeleteAccountRef ref) =>
    ref.read(authProvider).deleteAccount;

@Riverpod(dependencies: [auth])
Future<UserCredential> anonymousLogin(AnonymousLoginRef ref) =>
    ref.read(authProvider).anonymousUser;

/*@riverpod
Future<UserCredential?> googleLogin(GoogleLoginRef ref) =>
    ref.read(authProvider).googleLogin;

@riverpod
Future<UserCredential?> appleLogin(AppleLoginRef ref) =>
    ref.read(authProvider).appleLogin;*/

@Riverpod(dependencies: [auth])
Future nameChange(NameChangeRef ref, {required String userName}) async {
  final Auth auth = ref.read(authProvider);
  return auth.updateName(userName);
}

//@Riverpod(keepAlive: true, dependencies: [authUser])
//UserDatastore userDatastore(UserDatastoreRef ref) {
//  final User? user = ref.watch(authUserProvider).value;
//  final UserDatastore userDatastore = UserDatastore(ref, fUser: user);
//if (user != null) userDatastore.updateUser(user.uid);
//  return userDatastore;
//}

//@Riverpod(keepAlive: true, dependencies: [userDatastore])
//Future<Player?> player(PlayerRef ref) async =>
//    ref.watch(userDatastoreProvider).player;

/*@Riverpod(keepAlive: true, dependencies: [authUser])
UserDatastore userDatastore(UserDatastoreRef ref) {
  final User? user = ref.watch(authUserProvider).value;
  return UserDatastore(ref, fUser: user);
}*/

/*
@Riverpod(keepAlive: true, dependencies: [datastore])
Future<Player?> player(PlayerRef ref) async =>
    ref.watch(userDatastoreProvider).player;
*/

//https://riverpod.dev/docs/concepts/about_code_generation
