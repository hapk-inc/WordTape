import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wordtape/theme/colors.dart';

import '../model/puzzle.dart';
import 'board/fixed_board.dart';

@RoutePage()
class PuzzleBoardPage extends StatelessWidget {
  final Puzzle puzzle;
  const PuzzleBoardPage(this.puzzle, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: greenWhite,
        child: LayoutBuilder(
          builder: (_, constraint) {
            final double mW = constraint.maxWidth;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(leadingWidth: 60.r),
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
}
