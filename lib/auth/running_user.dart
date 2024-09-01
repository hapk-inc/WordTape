import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth.dart';

part 'running_user.g.dart';

@Riverpod(keepAlive: true, dependencies: [auth])
Stream<User?> runningUser(RunningUserRef ref) {
  final Auth auth = ref.read(authProvider);
  return auth.authUser;
}

@Riverpod(dependencies: [auth])
Future<bool> userLogin(UserLoginRef ref) async {
  final Auth auth = ref.read(authProvider);
  return auth.userLogin;
}
