import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../panel/widget.dart';
import '../../theme/color.dart';
import '../../theme/font.dart';
import '../../theme/pod.dart';

class HowToPlay extends PanelWidget {
  const HowToPlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DefaultTextTheme defaultTextTheme = DefaultTextTheme();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: height(),
      decoration: BoxDecoration(
        gradient: ref.read(gradientProvider(color: [seaWhite, azureGreen])),
      ),
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(15.r),
      constraints: BoxConstraints(maxWidth: 540.r),
      child: FadeIn(
        delay: const Duration(milliseconds: 300),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                "How to Play",
                style: defaultTextTheme.headlineLarge,
              ),
              RichText(
                text: TextSpan(
                  children: const <InlineSpan>[
                    const TextSpan(
                      text: "Objective: The objective is to create a "
                          "sequence of five interconnected words, "
                          "starting from a designated word. Starting Point: "
                          "The game begins with a starter word displayed on "
                          "the screen.Guessing Words: Players will guess the "
                          "next word in the sequence based on associations "
                          "with the previous words.Hints: If players need "
                          "assistance, they can view hints to help them "
                          "progress. Collaboration: Players can discuss "
                          "their guesses and hints with others to collaborate "
                          "on finding the correct sequence.",
                    )
                  ],
                  style: defaultTextTheme.bodySmall?.copyWith(color: slateGray),
                ),
              ),
              Center(
                child: FadeInUp(
                  delay: const Duration(milliseconds: 750),
                  child: SizedBox.square(
                    dimension: 300.r,
                    child: Lottie.asset('lottie/share.json'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  double height() => 600.r;

  @override
  SlideDirection direction() => SlideDirection.UP;

  @override
  bool backdropEnabled() => true;
}

TextSpan _pts(String title, String sub) => TextSpan(
      text: title,
      children: [
        const TextSpan(text: " : "),
        TextSpan(text: sub, style: const TextStyle(color: slateGray))
      ],
    );
