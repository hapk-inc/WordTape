import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../local/found.dart';
import '../local/pod.dart';
import '../local/puzzle.dart';
import 'auth.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
Auth auth(AuthRef ref) => Auth(ref);

/*@Riverpod(keepAlive: true, dependencies: [runningUser, router])
void listenAuth(ListenAuthRef ref) {
  ref.listen<User?>(
    runningUserProvider.select((auth) => auth.value),
    (_, next) async {
      final GoRouter router = ref.read(routerProvider);
      if (next == null) {
        ref.read(authNotifierProvider.notifier).state = ValidateAuth.notLogged;
        router.replace('/login');
      } else {
        log("$next");
        ref.read(authNotifierProvider.notifier).state =
            next.isAnonymous ? ValidateAuth.guest : ValidateAuth.inGame;
        router.replace('/home');
      }
    },
  );
}

@Riverpod(keepAlive: true, dependencies: [])
class AuthNotifier extends _$AuthNotifier {
  @override
  ValidateAuth build() => ValidateAuth.notLogged;

  @override
  set state(ValidateAuth value) {
    if (super.state == value) return;
    super.state = value;
  }
}*/

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

@Riverpod(dependencies: [auth])
Future<User?> fUser(FUserRef ref) async {
  final Auth auth = ref.read(authProvider);
  return auth.fUser;
}

@Riverpod(dependencies: [sqPuzzle, sqFound, auth])
Future<dynamic> logOff(LogOffRef ref) async {
  final LocalPuzzle localPuzzle = ref.read(sqPuzzleProvider);
  final LocalFound localFound = ref.read(sqFoundProvider);
  final Auth auth = ref.read(authProvider);
  return Future.wait([localPuzzle.delete(), localFound.delete(), auth.logOff]);
}
