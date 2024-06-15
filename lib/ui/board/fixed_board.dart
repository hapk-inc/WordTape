import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timelines/timelines.dart';
import 'package:wordtape/ui/board/hint_button.dart';

//
import '../../enum/enum.dart';
import '../../logic/auth/auth_notifier.dart';
import '../../logic/auth/bloc.dart';
import '../../logic/puzzle/bloc.dart';
import '../../logic/puzzle/found_notifier.dart';
import '../../model/found.dart';
import '../../model/puzzle.dart';
import '../../model/word.dart';
import '../../theme/colors.dart';
import 'puzzle_snack.dart';
import 'reveal_button.dart';
import 'word_pinput.dart';

//const Duration _sec45 = Duration(seconds: 90);

Connector get endConnector =>
    const DashedLineConnector(color: filledColor, gap: 3.6);

class FixedBoard extends ConsumerWidget {
  const FixedBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Puzzle? puzzle = ref.read(puzzleProvider).value;
    if (puzzle == null) return Container();

    listening(context, ref);
    //
    return FadeIn(
      delay: const Duration(milliseconds: 750),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          final double mW = constraints.maxWidth;
          return FixedTimeline.tileBuilder(
            theme: TimelineTheme.of(ctx).copyWith(
              nodePosition: 0,
              connectorTheme: ConnectorThemeData(
                thickness: mW * 0.0018,
                color: ashGray,
              ),
              indicatorTheme: IndicatorThemeData(
                size: mW * 0.0225,
                color: teal,
              ),
            ),
            builder: initTimelineBuilder(ref),
          );
        },
      ),
    );
  }
}

listening(BuildContext context, WidgetRef ref) {
  ref.listen<Found>(
    foundNotifierProvider.select((value) => value.found),
    (previous, next) async {
      ref.read(foundNotifierProvider.notifier).updateValidate();
      bool notLogged = ref.read(authNotifierProvider).notLogged;
      if (notLogged) await ref.read(anonymousLoginProvider.future);
      ref.read(datastoreProvider).updateFound(next);
    },
  );

  ref.listen<String?>(
    foundNotifierProvider.select((value) => value.found.mistake),
    (previous, next) {
      if (next != null) {
        //final double ratio = 900.h / 360.w;
        bool isBottom = true;

        Get.rawSnackbar(
          snackPosition: isBottom ? SnackPosition.BOTTOM : SnackPosition.TOP,
          snackStyle: isBottom ? SnackStyle.GROUNDED : SnackStyle.FLOATING,
          barBlur: 15,
          borderRadius: 15,
          messageText: const PuzzleSnack(),
          margin: isBottom
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 7.5),
          mainButton: ref.read(foundNotifierProvider).hasHint
              ? ref.read(foundNotifierProvider).seeHint
                  ? const RevealButton()
                  : const HintButton()
              : const RevealButton(),
        );
      }
    },
  );

/*  ref.listen(
    foundNotifierProvider.select((value) => value.found.hintUsed),
    (previous, next) {},
  );*/
}

TimelineTileBuilder initTimelineBuilder(WidgetRef ref) {
  final Puzzle p = ref.read(puzzleProvider).value!;
  final FoundNotifier notifier = ref.watch(foundNotifierProvider);

  return TimelineTileBuilder.connected(
    itemCount: p.words.length,
    contentsAlign: ContentsAlign.basic,
    contentsBuilder: (_, index) {
      final Word word = p.words[index];
      final WordValidate wv = notifier.validate[index];
      final double opacity = notifier.found.isCompleted
          ? 1
          : wv == WordValidate.alreadyFilled ||
                  wv == WordValidate.filled ||
                  wv == WordValidate.revealed
              ? 0.24
              : 1;
      return AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 300),
        child: Container(
          height: 60.h,
          padding: const EdgeInsets.only(left: 15),
          child: WordPinput(index, word),
        ),
      );
    },
    connectorBuilder: (_, index, __) {
      if (notifier.found.isCompleted) {
        return SolidLineConnector(
          color: notifier.validate[index] == WordValidate.error
              ? errorColor
              : filledColor,
        );
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
    indicatorBuilder: (_, index) {
      if (notifier.found.isCompleted) {
        return DotIndicator(
          color: notifier.validate[index] == WordValidate.error
              ? errorColor
              : filledColor,
        );
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
  );
}
