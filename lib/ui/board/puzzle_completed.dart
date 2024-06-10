import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../model/found.dart';
import '../../theme/colors.dart';
import 'trophy_lottie.dart';

class PuzzleCompleted extends ConsumerWidget {
  final Found found;
  const PuzzleCompleted(this.found, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final DateTime now = DateTime.now();
    final DateTime lastFound = found.lastFound ?? DateTime.now();
    final String str = now.day == lastFound.day
        ? "Today at ${DateFormat('h:mm a').format(lastFound)}"
        : DateFormat('MMMM d, y h:mm a').format(lastFound);
    return FadeIn(
      delay: const Duration(milliseconds: 1500),
      child: SizedBox(
        height: 210.h,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          elevation: 3.r,
          color: found.fullScore ? teal : raisinBlack,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TrophyLottie(found.fullScore),
                Gap(7.5.r),
                Text(
                  found.fullScore ? "Congratulations" : "Better Luck Next Time",
                  style: textTheme.titleSmall?.copyWith(
                    color: greenWhite,
                    height: 2.1,
                  ),
                ),
                Text(
                  "${found.revealed == null ? 5 : (5 - (found.revealed?.length ?? 0))} "
                  "out of 5 found. $str",
                  style: textTheme.labelSmall?.copyWith(
                    color: elbow,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
