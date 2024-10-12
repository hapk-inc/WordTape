import 'package:easy_localization/easy_localization.dart';
import 'package:mock_data/mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wordtape/enum/enum.dart';

import '../gen_ai/pod.dart';
import '../underline_text/pod.dart';
import 'notifier.dart';

part 'hint.g.dart';

@Riverpod(keepAlive: true)
class Hint extends _$Hint {
  @override
  String build(DateTime date) {
    final QuestionNotifier notifier = ref.read(questionNotifierProvider(date));
    if (notifier.focusedWord == null) {
      if (notifier.found.i == 6) {
        return "first_win_${mockInteger(0, 9)}".tr();
      } else {
        return ref.read(figureOutProvider);
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
    final QuestionNotifier notifier = ref.read(questionNotifierProvider(date));
    notifier.promptState = PromptState.search;
    if (notifier.focusedWord == null) {
      state = ref.read(figureOutProvider);
    } else {
      state = await ref.watch(createHintProvider(
        notifier.focusedWord!,
        notifier.answer,
      ).future);
    }
  }

  Future<void> helpUser(String answer, String? mistake) async {
    if (mistake != null) {
      final String help = await ref.watch(
        helpUserProvider(answer, mistake).future,
      );
      final QuestionNotifier notifier =
          ref.read(questionNotifierProvider(date));
      final bool isWrong = notifier.promptState == PromptState.wrong;
      if (isWrong) {
        state = help;
        await Future.delayed(
          const Duration(milliseconds: 2400),
          () {
            if (isWrong) state = "use_hint_${mockInteger(0, 7)}".tr();
          },
        );
      }
    }
  }
}
