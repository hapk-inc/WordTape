import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../firebase/pod.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
Stream<List<ConnectivityResult>> internetConnection(InternetConnectionRef ref) {
  final Connectivity connectivity = Connectivity();
  return connectivity.onConnectivityChanged;
}

@Riverpod(keepAlive: true, dependencies: [])
class ValidateConnection extends _$ValidateConnection {
  @override
  int build({int? value}) => value ?? 0;

  @override
  set state(int value) {
    debugPrint("Setting ValidateConnection $value");
    if (super.state == value) return;
    super.state = value;
  }
}

@Riverpod(keepAlive: true, dependencies: [
  internetConnection,
  remoteConfig,
])
void listenConnectivity(ListenConnectivityRef ref) {
  ref.listen<List<ConnectivityResult>?>(
    internetConnectionProvider.select((x) => x.value),
    (prev, next) async {
      if (next != null) {
        final bool valid = next.contains(ConnectivityResult.wifi) ||
            next.contains(ConnectivityResult.mobile);
        ref.read(validateConnectionProvider().notifier).state =
            valid ? await _validateConnection(ref) : -1;
      }
    },
    fireImmediately: true,
  );
}

Future<int> _validateConnection(ListenConnectivityRef ref) => ref
    .refresh(remoteConfigProvider)
    .fetchAndActivate()
    .then((value) => value ? 1 : 0)
    .onError(
      (e, __) => -1,
    );
