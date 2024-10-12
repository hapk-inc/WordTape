import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../../firebase/pod.dart';
import '../../logger/log.dart';
import '../../router/router.dart';
import '../connectivity/pod.dart';
import '../firestore/pod.dart';

import '../local/pod.dart';
import 'pod.dart';

part 'running_user.g.dart';

const Duration _m1500 = Duration(milliseconds: 1500);

@Riverpod(keepAlive: true, dependencies: [
  log,
  gUser,
  runningUser,
  internetConnection,
  router,
  localFound,
  localQuestion,
  remoteConfig,
  firestoreUser,
  auth
])
void listenAuth(ListenAuthRef ref) {
  ref.read(gUserProvider);

  ref.listen<User?>(runningUserProvider.select((value) => value.value),
      (prev, next) {
    final Logger log = ref.read(logProvider);
    log.i("RunningUser==");
    if (next != null) {
      if (prev == null) {
        ref.read(firestoreUserProvider).updateMe();
      }
      ref.read(routerProvider).replace("/home");
    } else {
      log.i("36==");
      if (prev != null) {
        ref.read(localQuestionProvider).delete();
        ref.read(localFoundProvider).delete();
        ref.read(routerProvider).replace('/');
      } else {
        log.i("Error");
        if (kIsWeb) {
          Future.delayed(_m1500, () => ref.read(authProvider).googleAuth);
        }
      }
    }
  }, fireImmediately: true);

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
