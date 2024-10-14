import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../logger/log.dart';
import '../../router/router.dart';
import '../firestore/pod.dart';

import '../local/pod.dart';
import 'pod.dart';

part 'running_user.g.dart';

const Duration _m1500 = Duration(milliseconds: 1500);

@Riverpod(keepAlive: true, dependencies: [
  log,
  googleUser,
  runningUser,
  // internetConnection,
  router,
  localFound,
  localQuestion,
  // remoteConfig,
  firestoreUser,
  auth
])
void listenAuth(ListenAuthRef ref) {
  ref.read(googleUserProvider);

  ref.listen<User?>(
    runningUserProvider.select((value) => value.value),
    (prev, next) {
      final Logger log = ref.read(logProvider);
      log.i("RunningUser==");
      if (next != null) {
        if (prev == null) {
          ref.read(firestoreUserProvider).updateMe();
          ref.read(routerProvider).replace("/home");
        }
      } else {
        log.i("36==");
        if (prev != null) {
          ref.read(localQuestionProvider).delete();
          ref.read(localFoundProvider).delete();
          ref.read(routerProvider).replace('/');
        } else {
          if (kIsWeb) {
            Future.delayed(_m1500, () => ref.read(authProvider).googleAuth);
          }
        }
      }
    },
    fireImmediately: true,
  );
/*  print("60==select");
  ref.listen<List<ConnectivityResult>>(
    internetConnectionProvider.select(
      //(x) => x.value?.last ?? ConnectivityResult.none,
      (x) {
        print("60==select==");
        return x.value ?? [];
      },
    ),
    (_, next) async {
      print("60==ConnectivityResult==");
      print(next);
      final bool valid =
          next == ConnectivityResult.wifi || next == ConnectivityResult.mobile;
      ref.read(validateConnectionProvider.notifier).state =
          valid ? await validateConnection(ref) : -1;
    },
    onError: (error, stackTrace) {
      print("75==ConnectivityResult==");
    },
    fireImmediately: true,
  );*/
}

/*Future<int> validateConnection(ListenAuthRef ref) =>
    ref.refresh(remoteConfigProvider).fetchAndActivate().then((value) {
      return value ? 1 : 0;
    }).onError(
      (e, __) {
        print("validateConnection");
        print(e);
        return -1;
      },
    );*/
