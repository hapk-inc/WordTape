import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'auth.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
Auth auth(AuthRef ref) => Auth(ref);

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

@Riverpod(dependencies: [auth])
Future<void> signingOff(SigningOffRef ref) {
  final Auth auth = ref.read(authProvider);
  return auth.logOff;
}

/*@Riverpod(keepAlive: true, dependencies: [
  runningUser,
  internetConnection,
  sqFound,
  sqPuzzle,
  remoteConfig,
  remotePlayer,
])
void listenAuth(ListenAuthRef ref) {
  ref.listen<User?>(
    runningUserProvider.select((value) => value.value),
        (previous, next) {
      if (previous != null && next == null) {
        log("Deleting");
        ref.read(sqFoundProvider).delete();
        ref.read(sqPuzzleProvider).delete();
      }
      if (next != null) {
        ref.read(remotePlayerProvider).updateMe();
      }
      ref.read(authNotifierProvider.notifier).validateAuth(next == null);
    },
  );

  ref.listen<ConnectivityResult>(
    internetConnectionProvider
        .select((x) => x.value?.last ?? ConnectivityResult.none),
        (_, next) async {
      final bool validConnection =
          next == ConnectivityResult.wifi || next == ConnectivityResult.mobile;
      ref.read(validateConnectionProvider.notifier).state =
      validConnection ? await validateConnection(ref) : -1;
    },
  );
}

Future<int> validateConnection(ListenAuthRef ref) => ref
    .refresh(remoteConfigProvider)
    .fetchAndActivate()
    .then((value) => value ? 1 : 0)
    .onError(
      (e, __) {
    log("RemoteConnection $e");
    return -1;
  },
);

@Riverpod(keepAlive: true, dependencies: [renovation, router])
class AuthNotifier extends _$AuthNotifier {
  @override
  RoutePath build() {
    final String renovation = ref.read(renovationProvider).value ?? "";
    final bool inMaintenance = renovation.isNotEmpty;
    if (inMaintenance) return const RoutePath(path: "/renovation");
    return const RoutePath();
  }

  @override
  set state(RoutePath value) {
    if (super.state == value) return;
    super.state = value;
    ref.read(routerProvider).replace(value.path, extra: value.arg);
  }

  validateAuth(bool isNull) {
    log("ValidateAuth--");
    return state = isNull ? const RoutePath() : const RoutePath(path: "/home");
  }
}*/
