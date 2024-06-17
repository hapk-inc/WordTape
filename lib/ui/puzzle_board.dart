import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../theme/colors.dart';
import '../ui/board/board_app_bar.dart';

import '../logic/puzzle/found_notifier.dart';
import '../model/puzzle.dart';
import 'board/fixed_board.dart';
import 'board/puzzle_completed.dart';

@RoutePage()
class PuzzleBoardPage extends ConsumerWidget {
  final Puzzle puzzle;
  const PuzzleBoardPage(this.puzzle, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FoundNotifier notifier = ref.watch(foundNotifierProvider);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (_, constraints) {
        final double mW = constraints.maxWidth;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BoardAppBar(),
              Container(
                height: 60.h * notifier.puzzle.words.length,
                margin: EdgeInsets.symmetric(horizontal: mW * 0.045),
                padding: EdgeInsets.only(left: mW * 0.012),
                alignment: Alignment.center,
                //color: ashGray,
                child: const FixedBoard(),
              ),
              Gap(30.r),
              if (notifier.found.isCompleted) ...[
                PuzzleCompleted(notifier.found)
              ] else ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (notifier.seeHint)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 750),
                        color: seaSalt,
                        alignment: Alignment.centerLeft,
                        height: !notifier.seeHint ? 0.h : 90.h,
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: !notifier.seeHint
                            ? null
                            : FadeIn(
                                delay: const Duration(milliseconds: 450),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Hint",
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: slateGray,
                                        height: 1.2,
                                      ),
                                    ),
                                    AutoSizeText(
                                      notifier.hint,
                                      style: textTheme.titleSmall?.copyWith(
                                        color: filledColor,
                                        height: 1.8,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    Gap(30.r),
                    if (notifier.wordNote != null)
                      FadeIn(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.r),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            padding: EdgeInsets.zero,
                            dashPattern: [9.r, 4.5.r],
                            color: ashGray,
                            strokeWidth: 1,
                            radius: Radius.circular(15.r),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                // color: greenWhite,
                              ),
                              height: 90.h,
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Note",
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: ashGray,
                                    ),
                                  ),
                                  AutoSizeText(
                                    notifier.wordNote ?? "No note",
                                    style: textTheme.titleSmall?.copyWith(
                                      color: verdiGris,
                                      height: 1.8,
                                    ),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                )
              ]
            ],
          ),
        );
      },
    );
  }
}
