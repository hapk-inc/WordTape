import 'package:easy_localization/easy_localization.dart';
import 'package:mock_data/mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../gen_ai/pod.dart';
import '../underline_text/pod.dart';
import 'notifier.dart';

part 'hint.g.dart';

@Riverpod(keepAlive: true)
class Hint extends _$Hint {
  @override
  String build(DateTime date) {
    final RiddleNotifier notifier = ref.read(riddleNotifierProvider(date));
    if (notifier.focusedWord == null) {
      if (notifier.found.i == 6) {
        return "first_win_${mockInteger(0, 9)}".tr();
      }
    }
    return ref
        .watch(createHintProvider(notifier.focusedWord!, notifier.answer))
        .when(
          data: (data) => data,
          error: (_, s) => ref.read(aiErrorProvider),
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
      notifier.focusedWord!,
      notifier.answer,
    ).future);
  }

  Future<void> helpUser(String answer, String? mistake) async {
    state = await ref.watch(helpUserProvider(answer, mistake ?? "").future);
    await Future.delayed(
      const Duration(milliseconds: 3600),
      () {
        if (mistake != null) {
          state = "use_hint_${mockInteger(0, 7)}".tr();
        }
      },
    );
  }
}
