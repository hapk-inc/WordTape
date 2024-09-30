import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../model/found.dart';

import '../../model/riddle.dart';
import 'found.dart';
import 'riddle.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
LocalFound sqFound(SqFoundRef ref) => LocalFound();

@Riverpod(keepAlive: true, dependencies: [sqFound])
Future<Found?> sqFoundArg(SqFoundArgRef ref, {String? id}) async {
  final LocalFound local = ref.read(sqFoundProvider);
  return id == null ? null : local.found(id);
}

////

@Riverpod(keepAlive: true, dependencies: [])
LocalRiddle sqRiddle(SqRiddleRef ref) => LocalRiddle();

@Riverpod(keepAlive: true, dependencies: [sqRiddle])
Future<Riddle?> sqRiddleArg(SqRiddleArgRef ref,
    {required DateTime date}) async {
  final LocalRiddle local = ref.read(sqRiddleProvider);
  return local.fromDate(date);
}
