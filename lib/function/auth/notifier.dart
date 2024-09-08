import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:logger/logger.dart';

import '../../firebase/pod.dart';
import '../../model/route_path.dart';
import '../connectivity/pod.dart';
//import '../logger/pod.dart';
import '../remote_config/pod.dart';
import 'pod.dart';

final ChangeNotifierProvider<AuthNotifier> authNotifierProvider =
    ChangeNotifierProvider<AuthNotifier>(
        (ref) => AuthNotifier(ref)..construct());

class AuthNotifier extends ChangeNotifier {
  final Ref ref;

  //late ValidateAuth _vAuth;

  //late Logger _logger;

  bool _inMaintenance = false;

  User? _fUser;

  bool _isConnected = true;

  RoutePath _path = const RoutePath("/");

  //bool _updateAvailable = false;

  AuthNotifier(this.ref) {
    //_logger = ref.read(logProvider);
    final String renovation = ref.read(renovationProvider).value ?? "";
    _inMaintenance = renovation.isNotEmpty;

    if (_inMaintenance) _path = const RoutePath("/renovation");

    // _vAuth = _inMaintenance ? ValidateAuth.renovation : ValidateAuth.notLogged;
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    log("AuthNotifier Override addListener");

    ref.listen<ConnectivityResult>(
      internetConnectionProvider
          .select((x) => x.value?.last ?? ConnectivityResult.none),
      (previous, next) async {
        final bool validConnection = next == ConnectivityResult.wifi ||
            next == ConnectivityResult.mobile;

        if (validConnection) return validateConnection();
        //ref.read(validateConnectionProvider.notifier).state = -1;
        isConnected = false;
        notifyListeners();
      },
    );

    /*ref.listen(
      validateConnectionProvider.select((value) => value),
      (previous, next) {
        _logger.i("netConnectedNotifierProvider $next");
        isConnected = !next.isNegative;
      },
    );*/
    if (!_inMaintenance) {
      log("Starting Running User");
      ref.listen<User?>(
        runningUserProvider.select((value) => value.value),
        (_, next) {
          log("AuthNotifier Listener Running $next");
          _fUser = next;
          path = RoutePath(next != null ? "/home" : "/");
        },
      );
    }
  }

  RoutePath get path => _path;

  set path(RoutePath value) {
    if (_path == value) {
      log("Same Route");
      return;
    }
    _path = value;
    notifyListeners();
  }

  //ValidateAuth get vAuth => _vAuth;

  User? get fUser => _fUser;

  /*set fUser(User? value) {
    if (_fUser == value) return;
    _fUser = value;
    notifyListeners();
  }*/

  bool get isConnected => _isConnected;

  set isConnected(bool value) {
    if (_isConnected == value) return;
    _isConnected = value;
    notifyListeners();
  }

  /*set vAuth(ValidateAuth value) {
    if (_vAuth == value) return;
    _vAuth = value;
    notifyListeners();
  }*/

  validateConnection() async {
    int connectionDone = await ref
        .refresh(remoteConfigProvider)
        .fetchAndActivate()
        .then((value) => value ? 1 : 0)
        .onError(
      (e, __) {
        log("RemoteConnection $e");
        return -1;
      },
    );
    log("RemoteConnected $connectionDone");
    //ref.read(validateConnectionProvider.notifier).state = connectionDone;
    isConnected = !connectionDone.isNegative;
  }

  construct() async {
    _fUser = await ref.read(fUserProvider.future);
    log("in Init $_fUser");
    path = RoutePath(_fUser == null ? "/" : "/home");
  }
}
