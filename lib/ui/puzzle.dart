import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../model/puzzle.dart';
import '../model/word.dart';
import 'dashboard.dart';
import 'puzzle/custom_keyboard.dart';
import 'theme/colors.dart';

class PuzzlePage extends ConsumerWidget {
  const PuzzlePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Puzzle puzzle = Puzzle.fromRandom();
    return ColoredBox(
      color: midnightGreen,
      child: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final double maxHeight = constraints.maxHeight;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15.r),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    // padding: _commonPuzzlePadding(constraint),
                    height: maxHeight * 0.15,
                    color: cerise,
                    alignment: Alignment.topLeft,
                    // child: PuzzleHint(id),
                  ),
                  for (Word word in puzzle.words) WordTextField(word),
                  Gap(maxHeight * 0.054),
                  const CustomKeyboard(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
