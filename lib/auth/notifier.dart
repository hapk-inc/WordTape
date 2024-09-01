import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../enums/validate_auth.dart';
import 'running_user.dart';

part 'notifier.g.dart';

@Riverpod(keepAlive: true, dependencies: [runningUser])
void listenAuth(ListenAuthRef ref) {
  ref.listen<User?>(
    runningUserProvider.select((auth) => auth.value),
    (_, next) async {
      if (next == null) {
        ref.read(authNotifierProvider.notifier).state = ValidateAuth.notLogged;
      } else {
        log("$next");
        ref.read(authNotifierProvider.notifier).state =
            next.isAnonymous ? ValidateAuth.guest : ValidateAuth.inGame;
      }
      //notifyListeners();
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
}
