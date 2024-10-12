import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../model/found.dart';

import '../../model/question.dart';
import 'found.dart';
import 'question.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
LocalFound localFound(LocalFoundRef ref) => LocalFound();

@Riverpod(keepAlive: true, dependencies: [localFound])
Future<Found?> localFoundArgId(LocalFoundArgIdRef ref, {String? id}) async {
  if (id == null) return null;
  final LocalFound localFound = ref.read(localFoundProvider);
  return localFound.found(id);
}

////

@Riverpod(keepAlive: true, dependencies: [])
LocalQuestion localQuestion(LocalQuestionRef ref) => LocalQuestion();

@Riverpod(keepAlive: true, dependencies: [localQuestion])
Future<Question?> localQuestionArgDate(LocalQuestionArgDateRef ref,
    {required DateTime date}) async {
  final LocalQuestion localQuestion = ref.read(localQuestionProvider);
  return localQuestion.fromDate(date);
}
