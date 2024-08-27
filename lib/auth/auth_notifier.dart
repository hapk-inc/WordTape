import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../enum/enum.dart';
import 'bloc.dart';

final ChangeNotifierProvider<AuthNotifier> authNotifierProvider =
    ChangeNotifierProvider<AuthNotifier>((ref) => AuthNotifier(ref));

class AuthNotifier extends ChangeNotifier {
  final Ref<AuthNotifier> ref;

  AuthValidate _authValidate = AuthValidate.notLogged;

  AuthNotifier(this.ref);

  @override
  void addListener(VoidCallback listener) {
    ref.listen<User?>(
      authUserProvider.select((auth) => auth.value),
      (_, next) async {
        if (next == null) {
          authValidate = AuthValidate.notLogged;
        } else {
          log("$next");
          authValidate =
              next.isAnonymous ? AuthValidate.guest : AuthValidate.loggedIn;
        }
      },
    );
    super.addListener(listener);
  }

  bool get notLogged => _authValidate == AuthValidate.notLogged;
  bool get loggedIn => _authValidate == AuthValidate.loggedIn;

  AuthValidate get authValidate => _authValidate;

  set authValidate(AuthValidate value) {
    if (_authValidate == value) return;
    _authValidate = value;
    notifyListeners();
  }
}
