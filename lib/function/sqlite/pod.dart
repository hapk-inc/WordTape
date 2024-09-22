import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'found.dart';
import 'puzzle.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
LocalPuzzle sqPuzzle(SqPuzzleRef ref) => LocalPuzzle();

@Riverpod(keepAlive: true, dependencies: [])
LocalFound sqFound(SqFoundRef ref) => LocalFound();
