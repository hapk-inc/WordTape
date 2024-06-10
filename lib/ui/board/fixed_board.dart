import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timelines/timelines.dart';
import 'package:wordtape/ui/board/hint_button.dart';

//
import '../../enum/enum.dart';
import '../../logic/auth/auth_notifier.dart';
import '../../logic/auth/bloc.dart';
import '../../logic/puzzle/bloc.dart';
import '../../logic/puzzle/found_notifier.dart';
import '../../model/puzzle.dart';
import '../../model/word.dart';
import '../../theme/colors.dart';
import 'reveal_button.dart';
import 'word_pinput.dart';

Connector get endConnector => const DashedLineConnector(
      color: filledColor,
      gap: 3.6,
    );

class FixedBoard extends ConsumerWidget {
  const FixedBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Puzzle? puzzle = ref.read(puzzleProvider).value;
    if (puzzle == null) return Container();
    ref.listen(
      foundNotifierProvider.select((value) => value.found),
      (_, next) {
        debugPrint("27-- $next");

        ref.read(foundNotifierProvider.notifier).updateValidate();
        if (next.i > 1) {
          bool notLogged = ref.read(authNotifierProvider).notLogged;
          if (notLogged) {
            ref.read(anonymousLoginProvider);
          } else {
            debugPrint("Update Found");
            ref.read(datastoreProvider).updateFound(next);
          }
        }
        if (next.mistake != null) {
          String w = puzzle.words[next.i].value;
          final bool showHint =
              !(ref.read(foundNotifierProvider).hintArr[next.i] ?? true);
          final ScaffoldMessengerState scaffoldMessengerState =
              ScaffoldMessenger.of(context);
          scaffoldMessengerState
              .showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Incorrect One"),
                      showHint
                          ? HintButton(puzzle.words[next.i].hint ?? "")
                          : RevealButton(w),
                    ],
                  ),
                ),
              )
              .closed
              .then(
            (SnackBarClosedReason reason) {
              debugPrint(reason.name);
              if (reason == SnackBarClosedReason.hide) {
                ref.read(foundNotifierProvider).revealWord(w);
              } else if (reason == SnackBarClosedReason.remove) {
                ref.read(foundNotifierProvider).updateHintFlag();
              }
            },
          );
        }
      },
    );

    final FoundNotifier notifier = ref.watch(foundNotifierProvider);
    return FadeIn(
      delay: const Duration(milliseconds: 750),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          final double mW = constraints.maxWidth;
          return FixedTimeline.tileBuilder(
            theme: TimelineTheme.of(ctx).copyWith(
              nodePosition: 0,
              connectorTheme:
                  ConnectorThemeData(thickness: mW * 0.0015, color: ashGray),
              indicatorTheme:
                  IndicatorThemeData(size: mW * 0.0225, color: teal),
            ),
            builder: TimelineTileBuilder.connected(
              itemCount: puzzle.words.length,
              contentsAlign: ContentsAlign.basic,
              contentsBuilder: (context, index) {
                final Word word = puzzle.words[index];
                final WordValidate wv = notifier.validate[index];

                return AnimatedOpacity(
                  opacity: notifier.found.isCompleted
                      ? 1
                      : wv == WordValidate.alreadyFilled ||
                              wv == WordValidate.filled ||
                              wv == WordValidate.revealed
                          ? 0.24
                          : 1,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    height: 60.h,
                    padding: EdgeInsets.only(left: mW * 0.03),
                    child: WordPinput(index, word),
                  ),
                );
              },
              connectorBuilder: (context, index, type) {
                if (notifier.found.isCompleted) {
                  return const SolidLineConnector(color: filledColor);
                } else {
                  switch (notifier.validate[index]) {
                    case WordValidate.idle:
                      return DashedLineConnector(color: idleColor, gap: 3.6.r);
                    case WordValidate.previous:
                      return const SolidLineConnector(color: teal);
                    case WordValidate.focused:
                      return const SolidLineConnector(color: focusedColor);
                    case WordValidate.error:
                      return DashedLineConnector(color: teal, gap: 3.6.r);
                    default:
                      return Container();
                  }
                }
              },
              indicatorBuilder: (context, index) {
                if (notifier.found.isCompleted) {
                  switch (notifier.validate[index]) {
                    case WordValidate.alreadyFilled:
                      return const DotIndicator(color: idleColor);
                    case WordValidate.filled:
                      return const DotIndicator(color: filledColor);
                    case WordValidate.revealed:
                      return const DotIndicator(color: errorColor);
                    default:
                      return Container();
                  }
                } else {
                  switch (notifier.validate[index]) {
                    case WordValidate.idle:
                      return const OutlinedDotIndicator(color: ashGray);
                    case WordValidate.previous:
                      return const DotIndicator(color: teal);
                    case WordValidate.focused:
                      return const DotIndicator(color: focusedColor);
                    case WordValidate.error:
                      return const DotIndicator(color: errorColor);
                    default:
                      return Container();
                  }
                }
              },
            ),
          );
        },
      ),
    );
  }
}
