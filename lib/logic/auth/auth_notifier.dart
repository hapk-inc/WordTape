import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../enum/enum.dart';
import 'bloc.dart';

//const Duration _sec30 = Duration(seconds: 30);

final ChangeNotifierProvider<AuthNotifier> authNotifierProvider =
    ChangeNotifierProvider<AuthNotifier>((ref) => AuthNotifier(ref));

class AuthNotifier extends ChangeNotifier {
  DateTime _dateTime = DateTime.now();
  final Ref<AuthNotifier> ref;

  AuthValidate _authValidate = AuthValidate.notLogged;

  AuthNotifier(this.ref);

  @override
  void addListener(VoidCallback listener) {
    ref.listen<User?>(
      authUserProvider.select((value) => value.value),
      (prev, next) async {
        //debugPrint("AuthNotifier addListening = $next");

        if (next == null) {
          _authValidate = AuthValidate.notLogged;
        } else {
          _authValidate =
              next.isAnonymous ? AuthValidate.guest : AuthValidate.loggedIn;
        }

        notifyListeners();
      },
    );
    super.addListener(listener);
  }

  DateTime get dateTime => _dateTime;

  set dateTime(DateTime value) {
    if (_dateTime == value) return;
    _dateTime = value;
    notifyListeners();
  }

  AuthValidate get authValidate => _authValidate;

  bool get notLogged => _authValidate == AuthValidate.notLogged;
  bool get loggedIn => _authValidate == AuthValidate.loggedIn;
}
