import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../function/local/found.dart';
import '../../function/puzzle/pod.dart';
import '../../model/puzzle.dart';
import '../theme/colors.dart';

class PCount extends ConsumerWidget {
  const PCount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime now = DateTime.now();
    final DateTime jun10 = ref.read(jun10Provider);
    final int difference = now.difference(jun10).inDays;

    final TextTheme textTheme = Theme.of(context).textTheme;

    return Positioned(
      top: 30.r,
      child: InkWell(
        onDoubleTap: () async {
          await LocalFound().delete();
          final DateTime date = ref.read(selectedDateProvider);
          final Puzzle? puzzle = ref.read(puzzleFromDateProvider(date)).value;
          ref.invalidate(foundFromPuzzleProvider(puzzle!));
        },
        child: Text(
          "NO. $difference",
          style: textTheme.headlineLarge?.copyWith(color: lightCyan),
        ),
      ),
    );
  }
}
