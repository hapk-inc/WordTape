import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wordtape/function/local/found.dart';
import 'package:wordtape/model/welcome.dart';

import '../enum/pod.dart';
import '../function/puzzle/pod.dart';
import '../model/found.dart';
import '../model/puzzle.dart';
import '../model/word.dart';
import 'dashboard/play_button.dart';
import 'dashboard/welcome.dart';
import 'puzzle/word_text_field.dart';
import 'theme/colors.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => LayoutBuilder(
        builder: (_, constraints) {
          final double mH = constraints.maxHeight;
          final double mW = constraints.maxWidth;
          final DateTime date = ref.watch(selectedDateProvider);
          final Puzzle? puzzle = ref.watch(puzzleFromDateProvider(date)).value;
          if (puzzle == null) return Container();
          final Found? found = ref.watch(foundFromPuzzleProvider(puzzle)).value;
          final Welcome welcome = found == null || found.i == 1
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
                          const PuzzleCount(),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                WelcomeText(welcome),
                                const Gap(60),
                                if (found != null)
                                  TwoWords(
                                    date,
                                    puzzle.guess(found),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Gap(mH * 0.015),
                OverflowBar(children: [PlayButton(puzzle)]),
              ],
            ),
          );
        },
      );
}

class TwoWords extends StatelessWidget {
  final DateTime date;
  final List<Word> twoWords;
  const TwoWords(this.date, this.twoWords, {super.key});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      delay: const Duration(milliseconds: 2400),
      child: Wrap(
        spacing: 15.r,
        children: List.from(twoWords.map((w) => WordTextField(
              w,
              needToDo: twoWords.last == w ? NeedToDo.onClick : NeedToDo.plain,
            ))),
      ),
    );
  }
}

class PuzzleCount extends ConsumerWidget {
  const PuzzleCount({super.key});

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
        },
        child: Text(
          "NO. $difference",
          style: textTheme.headlineLarge?.copyWith(color: lightCyan),
        ),
      ),
    );
  }
}
