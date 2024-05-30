import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../enum/enum.dart';
import 'auth/bloc.dart';

PanelController panelController = PanelController();

final ChangeNotifierProvider<DashboardNotifier> dashboardNotifierProvider =
    ChangeNotifierProvider<DashboardNotifier>(
  (ref) => DashboardNotifier(ref),
);

class DashboardNotifier extends ChangeNotifier {
  DateTime _dateTime = DateTime.now();
  final Ref<DashboardNotifier> ref;

  AuthValidate _authValidate = AuthValidate.notLogged;

  DashboardNotifier(this.ref);

  @override
  void addListener(VoidCallback listener) {
    ref.listen<User?>(
      authUserProvider.select((value) => value.value),
      (prev, n) {
        if (n == null) {
          _authValidate = AuthValidate.notLogged;
        } else {
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
}
