import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'auth.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
Auth auth(AuthRef ref) => Auth(ref);

@Riverpod(keepAlive: true, dependencies: [auth])
Stream<User?> runningUser(RunningUserRef ref) {
  final Auth auth = ref.read(authProvider);
  return auth.authUser;
}

@Riverpod(keepAlive: true, dependencies: [auth])
Stream<User?> gUser(GUserRef ref) {
  final Auth auth = ref.read(authProvider);
  return auth.onGoogleUser();
}

@Riverpod(dependencies: [auth])
Future<bool> userLogin(UserLoginRef ref) async {
  final Auth auth = ref.read(authProvider);
  return auth.userLogin;
}

@Riverpod(keepAlive: true, dependencies: [auth])
Future<User?> fUser(FUserRef ref) async {
  final Auth auth = ref.read(authProvider);
  return auth.fUser;
}

@Riverpod(dependencies: [auth])
Future<void> signingOff(SigningOffRef ref) {
  final Auth auth = ref.read(authProvider);
  return auth.logOff;
}

@Riverpod(keepAlive: true)
Future<PackageInfo> package(PackageRef ref) async => PackageInfo.fromPlatform();
