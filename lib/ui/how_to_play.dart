import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wordtape/router/my_route.dart';

import '../logic/puzzle/bloc.dart';
import '../model/puzzle.dart';
import '../model/word.dart';
import '../theme/colors.dart';
import 'board/word_pinput.dart';

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
                )
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
                          _pts(
                              "Five Words, One Chain",
                              "Each puzzle starts with five compound nouns "
                                  "or phrases arranged vertically.\n\n"),
                          _pts(
                            "Join the Tape",
                            "The second half of the first compound noun "
                                "becomes the first half of the second compound noun,"
                                " and so on, "
                                "creating a chain of connected words.\n\n",
                          ),
                          _pts(
                              "Fill in the Blanks",
                              "Your goal is to fill in the missing letters "
                                  "in each blank space to complete all five words.")
                        ],
                        style: textTheme.bodyMedium?.copyWith(
                          color: raisinBlack,
                          height: 1.8,
                        ),
                      ),
                    ),
                    Gap(15.h),
                    SizedBox(
                      height: 150.h,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: WordPinput(0, Word(value: "WASHING")),
                          ),
                          Flexible(
                            child: WordPinput(1, Word(value: "MACHINE")),
                          ),
                        ],
                      ),
                    ),
                    Gap(15.h),
                    RichText(
                      text: TextSpan(
                        children: [
                          _pts(
                            "Work Your Way Down",
                            "Start by focusing on the first word. "
                                "Once you've filled in the blanks there,"
                                " move on to the second word, and so on,"
                                " following the chain.",
                          ),
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
