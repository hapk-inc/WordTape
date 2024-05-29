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
            final double maxW = constraint.maxWidth;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(leadingWidth: 60.r),
                Gap(30.h),
                Container(
                  //color: ashGray,
                  height: constraint.maxHeight * 0.51,
                  margin: EdgeInsets.only(
                    left: maxW * 0.06,
                    right: maxW * 0.045,
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: maxW * 0.012),
                  child: const FixedBoard(),
                  //child: Container(),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
