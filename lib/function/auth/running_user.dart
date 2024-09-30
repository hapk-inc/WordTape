import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../../firebase/pod.dart';
import '../../router/router.dart';
import '../connectivity/pod.dart';
import '../sqlite/pod.dart';
import 'pod.dart';

part 'running_user.g.dart';

@Riverpod(keepAlive: true, dependencies: [
  runningUser,
  internetConnection,
  router,
  sqFound,
  sqRiddle,
  remoteConfig,
  // remotePlayer,
])
void listenAuth(ListenAuthRef ref) {
  ref.listen<User?>(
    runningUserProvider.select((value) => value.value),
    (prev, next) {
      log("25==listenAuth");
      if (next != null) {
        ref.read(routerProvider).replace("/home");
      } else {
        if (prev != null) {
          ref
            ..read(sqRiddleProvider).delete()
            ..read(sqFoundProvider).delete();
          ref.read(routerProvider).replace('/');
        }
      }
      /*if (prev != null && next == null) {
        ref.read(sqFoundProvider).delete();
        ref.read(sqRiddleProvider).delete();
      }
      if (next != null) {
        // ref.read(remotePlayerProvider).updateMe();
      }*/
      // ref.read(authNotifierProvider.notifier).validateAuth(next == null);
    },
  );

  ref.listen<ConnectivityResult>(
    internetConnectionProvider.select(
      (x) => x.value?.last ?? ConnectivityResult.none,
    ),
    (_, next) async {
      final bool valid =
          next == ConnectivityResult.wifi || next == ConnectivityResult.mobile;
      ref.read(validateConnectionProvider.notifier).state =
          valid ? await validateConnection(ref) : -1;
    },
  );
}

Future<int> validateConnection(ListenAuthRef ref) => ref
    .refresh(remoteConfigProvider)
    .fetchAndActivate()
    .then((value) => value ? 1 : 0)
    .onError((e, __) => -1);

/*
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
}
*/
