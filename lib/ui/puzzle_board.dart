import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wordtape/theme/colors.dart';

import '../logic/puzzle/found_notifier.dart';
import '../model/found.dart';
import '../model/puzzle.dart';
import 'board/board_app_bar.dart';
import 'board/fixed_board.dart';
import 'board/puzzle_note.dart';
import 'board/puzzle_completed.dart';

const Duration m750 = Duration(milliseconds: 750);

@RoutePage()
class PuzzleBoardPage extends ConsumerWidget {
  final Puzzle puzzle;
  const PuzzleBoardPage(this.puzzle, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Found? found = ref.watch(foundNotifierProvider).valueOrNull;

    ref.listen(
      foundNotifierProvider.select((value) => value.value),
      (previous, next) {},
      onError: (error, stackTrace) {},
    );

    return TooltipVisibility(
      visible: false,
      child: LayoutBuilder(
        builder: (_, constraint) {
          final double mW = constraint.maxWidth;
          return ColoredBox(
            color: greenWhite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BoardAppBar(),
                  Gap(15.h),
                  Container(
                    height: 60.h * puzzle.words.length,
                    margin: EdgeInsets.only(left: mW * 0.06, right: mW * 0.045),
                    alignment: Alignment.center,
                    //color: ashGray,
                    padding: EdgeInsets.symmetric(horizontal: mW * 0.012),
                    child: const FixedBoard(),
                  ),
                  if ((found?.isCompleted ?? false)) ...[
                    Gap(30.h),
                    const PuzzleCompleted()
                  ] else ...[
                    const PuzzleNote()
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/* SlidingUpPanel(
                      backdropColor: raisinBlack,
                      padding: EdgeInsets.symmetric(horizontal: 4.5.r),
                      backdropEnabled: true,
                      backdropOpacity: 0.75,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15.r),
                      ),
                      minHeight: 0,
                      maxHeight: panelWidget.height,
                      controller: boardPanel,
                      panel: panelWidget.child,
                    ),*/
