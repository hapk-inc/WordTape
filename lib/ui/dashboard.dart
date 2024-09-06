import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../function/puzzle/pod.dart';
import '../model/found.dart';
import '../model/puzzle.dart';
import '../model/welcome.dart';
import 'dashboard/p_count.dart';
import 'dashboard/pass_button.dart';
import 'dashboard/play_button.dart';
import 'dashboard/two_word.dart';
import 'dashboard/welcome.dart';
import 'theme/color.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => LayoutBuilder(
        builder: (_, constraints) {
          final double mH = constraints.maxHeight;
          final double mW = constraints.maxWidth;
          final DateTime date = ref.watch(selectedDateProvider);
          final Puzzle? puzzle =
              ref.watch(puzzleDateArgProvider(date: date)).when(
                    loading: () => null,
                    error: (error, stackTrace) {
                      debugPrintStack(stackTrace: stackTrace);
                      return null;
                    },
                    data: (data) => data,
                  );

          //
          if (puzzle == null) return Container(color: midnightGreen);

          //
          final Found? found =
              ref.watch(foundDateArgProvider(date: date)).value;
          if (found == null) return Container(color: midnightGreen);

          //
          final Welcome welcome = found.i == 1
              ? ref.read(welcomeProvider)
              : ref.read(resumeProvider);
          return SingleChildScrollView(
            child: Column(
              children: [
                FadeIn(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    color: midnightGreen,
                    constraints: BoxConstraints.expand(height: mH * 0.75),
                    padding: EdgeInsets.symmetric(horizontal: mW * 0.045),
                    child: SafeArea(
                      child: Stack(
                        children: [
                          const PCount(),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                WelcomeText(welcome),
                                const Gap(60),
                                TwoWord(date, puzzle.guess(found)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Gap(mH * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.r),
                  child: OverflowBar(
                    overflowAlignment: OverflowBarAlignment.center,
                    spacing: 15.r,
                    overflowSpacing: 15.r,
                    children: [PlayButton(puzzle), const PassButton()],
                  ),
                ),
              ],
            ),
          );
        },
      );
}
