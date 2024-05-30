import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wordtape/logic/puzzle/bloc.dart';
import 'package:wordtape/theme/colors.dart';

import '../model/puzzle.dart';
import 'board/fixed_board.dart';

@RoutePage()
class PuzzleBoardPage extends ConsumerWidget {
  final Puzzle puzzle;
  const PuzzleBoardPage(this.puzzle, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SafeArea(
        child: Container(
          color: greenWhite,
          child: LayoutBuilder(
            builder: (_, constraint) {
              final double mW = constraint.maxWidth;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBar(
                    leadingWidth: 60.r,
                    actions: [
                      if (kDebugMode)
                        IconButton(
                          onPressed: () =>
                              ref.read(foundNotifierProvider.notifier).delete(),
                          icon: const Icon(Icons.delete, color: ashGray),
                        ),
                      const Gap(7.5)
                    ],
                  ),
                  Gap(30.h),
                  Container(
                    height: 69.75.h * puzzle.words.length,
                    margin: EdgeInsets.only(left: mW * 0.06, right: mW * 0.045),
                    alignment: Alignment.center,
                    // color: ashGray,
                    padding: EdgeInsets.symmetric(horizontal: mW * 0.012),
                    child: const FixedBoard(),
                  )
                ],
              );
            },
          ),
        ),
      );
}
