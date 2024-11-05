import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../enum/enum.dart';
import '../../firebase/pod.dart';
import 'auth.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [env, appEnv])
Auth auth(Ref<Auth> ref) => Auth(ref);

@Riverpod(keepAlive: true, dependencies: [auth])
Stream<User?> runningUser(Ref ref) {
  final Auth auth = ref.read(authProvider);
  return auth.authUser;
}

@Riverpod(keepAlive: true, dependencies: [auth])
Stream<User?> googleUser(Ref ref) {
  final Auth auth = ref.read(authProvider);
  return auth.onGoogleUser;
}

@riverpod
Future<void> googleLogin(Ref<void> ref) async {
  final Auth auth = ref.read(authProvider);
  return auth.googleAuth;
}

@Riverpod(dependencies: [auth])
Future<bool> userLogin(Ref ref) async {
  final Auth auth = ref.read(authProvider);
  return auth.userLogin;
}

@Riverpod(keepAlive: true, dependencies: [auth])
Future<User?> fUser(Ref ref) async {
  final Auth auth = ref.read(authProvider);
  return auth.fUser;
}

@Riverpod(dependencies: [auth])
Future<void> signingOff(Ref ref) {
  final Auth auth = ref.read(authProvider);
  return auth.logOff;
}

@Riverpod(keepAlive: true)
Future<PackageInfo> package(Ref ref) async => PackageInfo.fromPlatform();
