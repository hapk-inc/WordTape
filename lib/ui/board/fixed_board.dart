import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timelines/timelines.dart';

import '../../enum/enum.dart';
import '../../logic/puzzle/found_notifier.dart';
import '../../model/found.dart';
import '../../model/puzzle.dart';
import '../../model/word.dart';
import '../../theme/colors.dart';
import 'word_pinput.dart';

class FixedBoard extends ConsumerStatefulWidget {
  const FixedBoard({super.key});

  @override
  ConsumerState createState() => _FixedBoardState();
}

class _FixedBoardState extends ConsumerState<FixedBoard> {
  late Puzzle puzzle;
  late Found found;

  WordValidate validation(int index, int rowNo) {
    //
    if (index == (rowNo - 1)) return WordValidate.previous;

    return index < rowNo
        ? WordValidate.alreadyFilled
        : index == rowNo
            ? found.mistake != null
                ? WordValidate.error
                : WordValidate.focused
            : WordValidate.idle;
  }

  Connector get endConnector => const DashedLineConnector(
        color: filledColor,
        gap: 3.6,
      );

  @override
  Widget build(BuildContext context) {
    found = ref.watch(foundNotifierProvider).valueOrNull ?? const Found();
    if (found.id == null) return Container();
    puzzle = ref.read(foundNotifierProvider.notifier).puzzle;
    return FadeIn(
        delay: const Duration(milliseconds: 750),
        child: LayoutBuilder(
          builder: (ctx, constraint) {
            final double mW = constraint.maxWidth;
            final double mH = constraint.maxHeight;
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
                contentsBuilder: (_, index) {
                  WordValidate validate = validation(index, found.i);

                  final Word word =
                      puzzle.words[index].copyWith(validate: validate);
                  return Container(
                    height: mH / puzzle.words.length,
                    padding: EdgeInsets.only(left: mW * 0.03),
                    child: WordPinput(index, word),
                  );
                },
                firstConnectorBuilder: (_) => endConnector,
                lastConnectorBuilder: (_) => endConnector,
                connectorBuilder: (_, index, __) {
                  WordValidate validate = validation(index, found.i);
                  switch (validate) {
                    case WordValidate.filled:
                      return const SolidLineConnector(color: filledColor);
                    case WordValidate.previous:
                      return const SolidLineConnector(color: focusedColor);
                    case WordValidate.focused:
                      return const SolidLineConnector(color: focusedColor);
                    case WordValidate.idle:
                      return DashedLineConnector(color: idleColor, gap: 3.6.r);
                    case WordValidate.error:
                      return const SolidLineConnector(color: errorColor);
                    case WordValidate.alreadyFilled:
                      return const SolidLineConnector(color: prussianBlue);
                  }
                },
                indicatorBuilder: (_, index) {
                  WordValidate validate = validation(index, found.i);
                  switch (validate) {
                    case WordValidate.filled:
                      return const DotIndicator(color: filledColor);
                    case WordValidate.previous:
                      return const DotIndicator(color: filledColor);
                    case WordValidate.focused:
                      return const DotIndicator(color: focusedColor);
                    case WordValidate.idle:
                      return const OutlinedDotIndicator(color: ashGray);
                    case WordValidate.error:
                      return const DotIndicator(color: errorColor);
                    case WordValidate.alreadyFilled:
                      return const DotIndicator(color: idleColor);
                  }
                },
              ),
            );
          },
        ));
  }
}

/*  @override
  void initState() {
    //final args = context.router.current.args;
    //puzzle = args is PuzzleBoardRouteArgs ? args.puzzle : Puzzle.fromRandom();
    //puzzle = ref.read(foundNotifierProvider.notifier).puzzle;
    //puzzle = ref.read(puzzleProvider).value!;
    /*found = ref.refresh(foundNotifierProvider.notifier).state.value ??
        const Found();*/
/*    found = ref.refresh(foundNotifierProvider.notifier).state.when(
          data: (data) => data,
          error: (error, stackTrace) {
            debugPrintStack(stackTrace: stackTrace);
            return Found();
          },
          loading: () => Found(),
        );*/
    super.initState();
  }
*/
