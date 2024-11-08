import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../enum/enum.dart';
import '../../router/router.dart';
import '../connectivity/pod.dart';
import '../firestore/pod.dart';

import '../local/found.dart';
import '../local/question.dart';
import 'pod.dart';

part 'running_user.g.dart';

// const Duration _m1500 = Duration(milliseconds: 1500);

@Riverpod(keepAlive: true, dependencies: [
  tracker,
  runningUser,
  router,
  ValidateConnection,
  firestoreUser,
  auth,
  googleUser
])
void listenAuth(Ref ref) {
  ref.read(googleUserProvider);

  ref.listen<User?>(
    runningUserProvider.select((value) => value.value),
    (prev, next) {
      final Logger tracker = ref.read(trackerProvider);
      tracker.i("RunningUser==");
      print(next?.uid ?? "nullUser");

      if (next != null) {
        if (prev == null) {
          final int valid = ref.read(validateConnectionProvider());
          final bool isAnonymous = next.isAnonymous;
          if (!valid.isNegative && !isAnonymous) {
            ref.read(firestoreUserProvider).updateMe();
          }
        }
      } else {
        if (prev != null) {
          LocalQuestion.delete();
          LocalFound.delete();
          final GoRouter router = ref.read(routerProvider);
          router.replace('/');
        } /*else {
          if (kIsWeb) {
            Future.delayed(_m1500, () => ref.read(authProvider).googleAuth);
          }
        }*/
      }
    },
    fireImmediately: true,
  );
}
