import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../logger/log.dart';
import '../../router/router.dart';
import '../connectivity/pod.dart';
import '../firestore/pod.dart';

import '../local/found.dart';
import '../local/question.dart';
import 'pod.dart';

part 'running_user.g.dart';

const Duration _m1500 = Duration(milliseconds: 1500);

@Riverpod(keepAlive: true, dependencies: [
  log,
  // googleUser,
  runningUser,
  // internetConnection,
  router,
  // localFound,
  // localQuestion,
  // remoteConfig,
  ValidateConnection,
  firestoreUser,
  auth
])
void listenAuth(ListenAuthRef ref) {
  // ref.read(googleUserProvider);

  ref.listen<User?>(
    runningUserProvider.select((value) => value.value),
    (prev, next) {
      final Logger log = ref.read(logProvider);
      log.i("RunningUser==");
      if (next != null) {
        if (prev == null) {
          final int validConnection = ref.read(validateConnectionProvider());
          if (!validConnection.isNegative) {
            ref.read(firestoreUserProvider).updateMe();
          }
          ref.read(routerProvider).replace("/home");
        }
      } else {
        log.i("36==");
        if (prev != null) {
          LocalQuestion().delete();
          LocalFound().delete();
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
}
