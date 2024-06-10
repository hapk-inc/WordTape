import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wordtape/model/word.dart';
import 'package:wordtape/router/my_route.dart';
import 'package:wordtape/ui/board/pinput_demo.dart';

import '../logic/puzzle/bloc.dart';
import '../model/puzzle.dart';
import '../theme/colors.dart';

const String _text1 = "Each puzzle starts with five compound nouns or "
    "phrases arranged vertically.";

const String _text2 = "The second half of the first compound noun becomes the "
    "first half of the second compound noun, and so on, creating a chain of connected words.";

const String _text3 = "Your goal is to fill in the missing letters in each "
    "blank space to complete all five words.";

const String _text4 = "Start by focusing on the first word. Once you've "
    "filled in the blanks there, move on to the second word, and so on,"
    " following the chain.";

//TextSpan get _singleLine => const TextSpan(text: "\n");
TextSpan get _doubleLine => const TextSpan(text: "\n\n");

@RoutePage()
class HowToPlayPage extends StatelessWidget {
  final bool understand;

  const HowToPlayPage({this.understand = false, super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return ColoredBox(
      color: greenWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            toolbarHeight: 75.h,
            actions: [
              if (understand)
                Consumer(
                  builder: (_, ref, __) => TextButton(
                    onPressed: () {
                      final Puzzle? puzzle =
                          ref.read(puzzleProvider).valueOrNull;
                      context.router.replace(PuzzleBoardRoute(puzzle: puzzle!));
                    },
                    child: const Text("I UNDERSTAND"),
                  ),
                ),
              // const Gap(15)
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.r),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "How to Play?",
                      style: textTheme.titleMedium?.copyWith(
                        color: teal,
                        height: 2.1,
                      ),
                    ),
                    const Text(
                      "Create a 6-word combination sequence",
                      style: TextStyle(color: slateGray),
                    ),
                    Gap(30.h),
                    RichText(
                      text: TextSpan(
                        children: [
                          _pts("Five Words, One Chain", _text1),
                          _doubleLine,
                          _pts("Join the Tape", _text2),
                          _doubleLine,
                          _pts("Fill in the Blanks", _text3)
                        ],
                        style: textTheme.bodyMedium?.copyWith(
                          color: raisinBlack,
                          height: 1.8,
                        ),
                      ),
                    ),
                    Gap(15.r),
                    Container(
                      color: seaSalt,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(7.5.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(15.h),
                          const AutoSizeText.rich(
                            TextSpan(
                              text: "Ex: ",
                              children: [
                                TextSpan(text: "WASHING "),
                                TextSpan(text: "MACHINE"),
                              ],
                              style: TextStyle(color: teal),
                            ),
                          ),
                          SizedBox(
                            height: 150.h,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PinputDemo(0, Word(value: "WASHING")),
                                PinputDemo(1, Word(value: "MACHINE")),
                              ],
                            ),
                          ),
                          Gap(15.h),
                          const AutoSizeText.rich(
                            TextSpan(
                              text: "Ex: ",
                              children: [
                                TextSpan(text: "WEB"),
                                TextSpan(text: "SITE"),
                              ],
                              style: TextStyle(color: teal),
                            ),
                          ),
                          SizedBox(
                            height: 150.h,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PinputDemo(0, Word(value: "WEB")),
                                PinputDemo(1, Word(value: "SITE")),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(15.r),
                    RichText(
                      text: TextSpan(
                        children: [
                          _pts("Work Your Way Down", _text4),
                        ],
                        style: textTheme.bodyMedium?.copyWith(
                          color: raisinBlack,
                          height: 1.8,
                        ),
                      ),
                    ),
                    Gap(30.h),
                    Text(
                      "Tips & Tricks",
                      style: textTheme.titleSmall?.copyWith(
                        color: teal,
                        height: 2.1,
                      ),
                    ),
                    Gap(15.h),
                    RichText(
                      text: TextSpan(
                        children: [
                          _pts(
                              "Think creatively",
                              "Don't just focus on common words. "
                                  "Consider synonyms and less obvious "
                                  "connections between the phrases.\n\n"),
                          _pts(
                            "Stuck? Don't worry!",
                            "Use the hint button "
                                "(if available) for a "
                                "nudge in the right direction.\n",
                          ),
                          const TextSpan(text: "Have Fun!")
                        ],
                        style: textTheme.bodyMedium?.copyWith(
                          color: raisinBlack,
                          height: 1.8,
                        ),
                      ),
                    ),
                    Gap(90.h),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  TextSpan _pts(String title, String sub) => TextSpan(
        text: title,
        children: [
          const TextSpan(text: " : "),
          TextSpan(text: sub, style: const TextStyle(color: slateGray))
        ],
      );
}
