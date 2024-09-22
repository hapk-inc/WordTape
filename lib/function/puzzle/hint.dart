import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/welcome.dart';
import '../gen_ai/pod.dart';
import 'notifier.dart';

part 'hint.g.dart';

@Riverpod(keepAlive: true, dependencies: [createHint, recallNext, helpUser])
class HintNotifier extends _$HintNotifier {
  @override
  String build(DateTime date) {
    log("Initiating", name: "Hint Notifier");
    final PuzzleNotifier notifier = ref.watch(puzzleNotifierProvider(date));
    final String recall = ref.read(recallNextProvider);

    if (notifier.isCompleted) return ref.read(completePuzzleProvider);
    if (notifier.tip != null) {
      return notifier.tip?.text ?? "";
    } else if (notifier.found.mistake == null) {
      return ref
          .watch(createHintProvider(
              word: notifier.currentWord, answer: notifier.next))
          .maybeWhen(
            data: (data) => data,
            orElse: () => recall,
            error: (e, s) {
              debugPrintStack(stackTrace: s);
              return notifier.localHint ?? "Looks like you're own. $recall";
            },
          );
    } else {
      return ref
          .watch(helpUserProvider(
              word: notifier.next, mistake: notifier.mistakeCombination))
          .maybeWhen(
            data: (data) => data,
            orElse: () => "Let me think",
            error: (e, _) => "That's not correct. Use Hint button",
          );
    }
  }

  @override
  set state(String value) {
    if (super.state == value) return;
    super.state = value;
  }
}
