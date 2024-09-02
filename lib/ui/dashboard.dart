import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:wordtape/model/found.dart';

import '../logic/puzzle/pod.dart';
import '../model/puzzle.dart';
import '../model/word.dart';
import 'dashboard/play_button.dart';
import 'dashboard/welcome.dart';
import 'theme/colors.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => LayoutBuilder(
        builder: (_, constraints) {
          final double mH = constraints.maxHeight;
          final double mW = constraints.maxWidth;
          final Puzzle puzzle = Puzzle.fromRandom();
          final Found found = Found(date: DateTime.now());
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
                          const PuzzleNo(),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const WelcomeText(),
                                const Gap(60),
                                TwoWords(puzzle.guess(found)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Gap(mH * 0.015),
                OverflowBar(children: [PlayButton(Puzzle.fromRandom())]),
              ],
            ),
          );
        },
      );
}

class TwoWords extends StatelessWidget {
  final List<Word> twoWords;
  const TwoWords(this.twoWords, {super.key});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      delay: const Duration(milliseconds: 2400),
      child: Wrap(
        spacing: 60.r,
        children: List.from(twoWords.map((w) => WordTextField(w))),
      ),
    );
  }
}

class WordTextField extends ConsumerWidget {
  final Word word;
  const WordTextField(this.word, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      constraints: BoxConstraints(maxWidth: 450.r, minHeight: 75.h),
      //alignment: Alignment.center,

      child: LayoutBuilder(
        builder: (_, constraints) {
          return Pinput(
            length: word.value.length,
            defaultPinTheme: ref.read(
              pinThemeProvider(constraints: constraints, color: seaWhite),
            ),
            controller: TextEditingController(text: word.value),

            //
            isCursorAnimationEnabled: false,
            animationDuration: const Duration(milliseconds: 150),
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            //validator: (value) {},
            //
            //keyboardType: TextInputType.none,
            //readOnly: true,
            showCursor: false,
            //enabled: controller == notifier.activeController,

            textCapitalization: TextCapitalization.characters,
            separatorBuilder: (_) => SizedBox(
              width: word.value.length > 8 ? 4.5.r : 7.5.r,
            ),
            //
          );
        },
      ),
    );
  }
}

class PuzzleNo extends ConsumerWidget {
  const PuzzleNo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime now = DateTime.now();
    final DateTime jun10 = ref.read(jun10Provider);
    final int difference = now.difference(jun10).inDays;

    final TextTheme textTheme = Theme.of(context).textTheme;

    return Positioned(
      top: 30.r,
      child: Text(
        "NO. $difference",
        style: textTheme.headlineLarge?.copyWith(color: lightCyan),
      ),
    );
  }
}
