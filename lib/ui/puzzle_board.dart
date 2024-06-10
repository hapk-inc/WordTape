import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
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
              if (notifier.found.isCompleted) ...[
                Gap(30.r),
                PuzzleCompleted(notifier.found)
              ]
            ],
          ),
        );
      },
    );
  }
}
