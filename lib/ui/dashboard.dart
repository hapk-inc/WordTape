import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dashboard/welcome.dart';
import 'theme/colors.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      LayoutBuilder(builder: (_, constraints) {
        final double mH = constraints.maxHeight;
        final double mW = constraints.maxWidth;
        return SingleChildScrollView(
          child: Column(
            children: [
              FadeIn(
                child: AnimatedContainer(
                  height: mH * 0.75,
                  duration: const Duration(milliseconds: 300),
                  color: midnightGreen,
                  //alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: mW * 0.045),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WelcomeText(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
}

/*Here are 10 rephrased questions, each with 15 words or fewer:
What word do you think comes next after this one?
Can you guess what the next word will be?
What word follows this one in the sequence?
Which word do you think is next?
What do you think the next word is?
Can you tell me the next word?
What word comes after this one, in your opinion?
What do you believe is the next word?
Which word do you think will come next?
What’s your guess for the next word?*/
