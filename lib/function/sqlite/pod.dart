import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../model/found.dart';

import 'found.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
LocalFound sqFound(SqFoundRef ref) => LocalFound();

@Riverpod(keepAlive: true, dependencies: [sqFound])
Future<Found?> sqFoundArg(SqFoundArgRef ref, {String? id}) async {
  final LocalFound local = ref.read(sqFoundProvider);
  return id == null ? null : local.found(id);
}
