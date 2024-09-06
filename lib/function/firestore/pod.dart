import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'found.dart';
import 'puzzle.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
RemotePuzzle remotePuzzle(RemotePuzzleRef ref) => RemotePuzzle(ref);

@Riverpod(keepAlive: true, dependencies: [])
RemoteFound remoteFound(RemoteFoundRef ref) => RemoteFound(ref);
