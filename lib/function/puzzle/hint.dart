import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wordtape/model/welcome.dart';

import '../gen_ai/pod.dart';
import 'notifier.dart';

part 'hint.g.dart';

/*
@Riverpod(keepAlive: true)
void listenHint(ListenHintRef ref, DateTime date) {
  ref.listen<Found>(
    puzzleNotifierProvider(date).select((value) => value.found),
    (previous, next) {
      log("$next", name: "Listening Hint");
      final String recall = ref.read(recallNextProvider);
      final PuzzleNotifier notifier = ref.watch(puzzleNotifierProvider(date));
      if (next.mistake == null) {
        ref.read(hintNotifierProvider(date).notifier).state = ref
            .watch(createHintProvider(word: notifier.next))
            .maybeWhen(
              data: (data) => data,
              orElse: () => recall,
              error: (__, _) {
                return notifier.localHint ?? "Looks like you're own. $recall";
              },
            );
      } else {
        ref.read(hintNotifierProvider(date).notifier).state = ref
            .watch(helpUserProvider(
                word: notifier.next, mistake: notifier.mistakeCombination))
            .maybeWhen(
              data: (data) => data,
              orElse: () => "Let me think",
              error: (e, _) => "That's not correct. Use Hint button",
            );
      }
    },
  );
}
*/

@Riverpod(keepAlive: true, dependencies: [createHint, recallNext, helpUser])
class HintNotifier extends _$HintNotifier {
  @override
  String build(DateTime date) {
    log("Initiating", name: "Hint Notifier");
    final PuzzleNotifier notifier = ref.watch(puzzleNotifierProvider(date));
    final String recall = ref.read(recallNextProvider);

    if (notifier.isCompleted) return ref.read(completePuzzleProvider);

    if (notifier.found.mistake == null) {
      return ref
          .watch(createHintProvider(
            word: notifier.currentWord,
            answer: notifier.next,
          ))
          .maybeWhen(
            data: (data) => data,
            orElse: () => recall,
            error: (__, _) {
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
