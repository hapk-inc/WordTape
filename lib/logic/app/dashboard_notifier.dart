import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../enum/enum.dart';
import '../auth/bloc.dart';
import '../puzzle/bloc.dart';

final ChangeNotifierProvider<AppNotifier> appNotifierProvider =
    ChangeNotifierProvider<AppNotifier>(
  (ref) => AppNotifier(ref),
);

class AppNotifier extends ChangeNotifier {
  DateTime _dateTime = DateTime.now();
  final Ref<AppNotifier> ref;

  AuthValidate _authValidate = AuthValidate.notLogged;

  AppNotifier(this.ref);

  @override
  void addListener(VoidCallback listener) {
    ref.listen<User?>(
      authUserProvider.select<User?>((value) => value.value),
      (prev, n) {
        if (n == null) {
          _authValidate = AuthValidate.notLogged;
        } else {
          if (n.isAnonymous && prev == null) {
            ref.read(datastoreProvider).createUser;
          }
          _authValidate =
              n.isAnonymous ? AuthValidate.guest : AuthValidate.loggedIn;
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
