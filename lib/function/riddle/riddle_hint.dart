import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../gen_ai/pod.dart';
import '../underline_text/pod.dart';
import 'notifier.dart';

part 'riddle_hint.g.dart';

@Riverpod(keepAlive: true)
class RiddleHint extends _$RiddleHint {
  @override
  String build(DateTime date) {
    final RiddleNotifier notifier = ref.read(riddleNotifierProvider(date));

    return ref
        .watch(createHintProvider(notifier.activeWord, notifier.answer))
        .when(
          data: (data) => data,
          error: (e, s) {
            return ref.read(aiErrorProvider);
          },
          loading: () => ref.read(figureOutProvider),
        );
  }

  @override
  set state(String value) {
    if (super.state == value) return;
    super.state = value;
  }

  Future<void> rearrange() async {
    final RiddleNotifier notifier = ref.read(riddleNotifierProvider(date));
    state = await ref.watch(createHintProvider(
      notifier.activeWord,
      notifier.answer,
    ).future);
  }

  Future<void> helpUser() async {
    final RiddleNotifier notifier = ref.read(riddleNotifierProvider(date));
    state = await ref.watch(helpUserProvider(
      notifier.answer,
      notifier.found.mistake ?? "",
    ).future);
  }
}
