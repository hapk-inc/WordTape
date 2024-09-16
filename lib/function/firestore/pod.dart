import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../auth/pod.dart';
import 'found.dart';
import 'player.dart';
import 'puzzle.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
RemotePuzzle remotePuzzle(RemotePuzzleRef ref) => RemotePuzzle(ref);

@Riverpod(keepAlive: true, dependencies: [runningUser])
RemoteFound remoteFound(RemoteFoundRef ref) {
  final User? user = ref.watch(runningUserProvider).value;
  return RemoteFound(ref, fUser: user);
}

@Riverpod(keepAlive: true, dependencies: [runningUser])
RemotePlayer remotePlayer(RemotePlayerRef ref) {
  final User? user = ref.watch(runningUserProvider).value;
  final RemotePlayer remotePlayer = RemotePlayer(ref, fUser: user);
  return remotePlayer;
}
