import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
Stream<List<ConnectivityResult>> internetConnection(InternetConnectionRef ref) {
  final Connectivity connectivity = Connectivity();
  return connectivity.onConnectivityChanged;
}

@Riverpod(keepAlive: true, dependencies: [])
class ValidateConnection extends _$ValidateConnection {
  @override
  int build() => -1;

  @override
  set state(int value) {
    log("Setting ValidateConnection $value");
    if (super.state == value) return;
    super.state = value;
  }
}
