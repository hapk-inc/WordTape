import 'package:firebase_auth/firebase_auth.dart';
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
void listenAuth(ListenAuthRef ref) {
  // ref.read(googleUserProvider);

  ref.listen<User?>(
    runningUserProvider.select((value) => value.value),
    (prev, next) {
      final Logger tracker = ref.read(trackerProvider);
      tracker.i("RunningUser==");
      if (next != null) {
        if (prev == null) {
          final int validConnection = ref.read(validateConnectionProvider());
          if (!validConnection.isNegative) {
            ref.read(firestoreUserProvider).updateMe();
          }
          // ref.read(routerProvider).replace("/home");
        }
      } else {
        tracker.i("36==");
        if (prev != null) {
          LocalQuestion().delete();
          LocalFound().delete();
          ref.read(routerProvider).replace('/');
        } else {
          /*if (kIsWeb) {
            Future.delayed(_m1500, () => ref.read(authProvider).googleAuth);
          }*/
        }
      }
    },
    fireImmediately: true,
  );
}
