import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../firebase/firebase.dart';

part 'config.g.dart';

@Riverpod(dependencies: [remoteConfig])
Future<String?> renovation(RenovationRef ref) async {
  final FirebaseRemoteConfig rc = ref.read(remoteConfigProvider);
  return rc.getString('renovation');
}
