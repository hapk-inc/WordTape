import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mock_data/mock_data.dart';
import 'package:timelines/timelines.dart';

import '../../enum/enum.dart';
import '../../model/found.dart';
import '../../model/puzzle.dart';
import '../../router/my_route.dart';
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

  @override
  void initState() {
    final args = context.router.current.args;
    //puzzle =  (context.router.current.args as PuzzleBoardRouteArgs).puzzle;
    puzzle = args is PuzzleBoardRouteArgs ? args.puzzle : Puzzle.fromRandom();
    //puzzle = Puzzle.fromRandom();

    final int random = mockInteger(1, 3);
    found = Found(
      rowNo: random,
      mistake: random == 2 ? puzzle.words[1].value : null,
    );
    super.initState();
  }

  WordValidate validation(int index) => index < found.rowNo
      ? WordValidate.alreadyFilled
      : index == found.rowNo
          ? found.mistake != null
              ? WordValidate.error
              : WordValidate.focused
          : WordValidate.idle;

  DashedLineConnector get endConnector =>
      DashedLineConnector(color: filledColor, gap: 3.6.h);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final double maxW = constraints.maxWidth;
        final double maxH = constraints.maxHeight;
        return FixedTimeline.tileBuilder(
          theme: TimelineTheme.of(ctx).copyWith(
            nodePosition: 0,
            connectorTheme: ConnectorThemeData(
              thickness: maxW * 0.0015,
              color: ashGray,
            ),
            indicatorTheme: IndicatorThemeData(
              size: maxW * 0.0225,
              color: teal,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            itemCount: puzzle.words.length,
            contentsAlign: ContentsAlign.basic,
            contentsBuilder: (_, index) {
              WordValidate validate = validation(index);

              return Container(
                height: maxH / puzzle.words.length,
                padding: EdgeInsets.only(left: maxW * 0.03),
                child: WordPinput(
                  index,
                  puzzle.words[index].copyWith(validate: validate),
                ),
              );
            },
            firstConnectorBuilder: (_) => endConnector,
            lastConnectorBuilder: (_) => endConnector,
            connectorBuilder: (_, index, __) {
              WordValidate validate = validation(index);
              switch (validate) {
                case WordValidate.filled:
                  return const SolidLineConnector(color: filledColor);
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
              WordValidate validate = validation(index);
              switch (validate) {
                case WordValidate.filled:
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
              return const DotIndicator(color: idleColor);
            },
          ),
        );
      },
    );
  }
}
