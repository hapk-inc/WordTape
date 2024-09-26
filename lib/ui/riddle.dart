import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import '../model/word.dart';
import '../riddle/notifier.dart';
import 'common/custom_keyboard.dart';
import 'common/editable_word.dart';
import 'common/gradient_box.dart';
import 'common/riddle_help.dart';

class RiddlePage extends ConsumerWidget {
  final DateTime date;
  const RiddlePage(this.date, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final RiddleNotifier notifier = ref.read(riddleNotifierProvider(date));

    //

    //final Puzzle puzzle = notifier.puzzle;
    return GradientBox(
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (_, constraints) {
            final double maxHeight = constraints.maxHeight - 90.h;
            final double maxWidth = constraints.maxWidth;
            final double h_03 = maxHeight * 0.03;
            final double w_03 = maxWidth * 0.03;
            return Form(
              key: notifier.formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      toolbarHeight: 90.h,
                      title: const Text("WORDTAPE"),
                      actions: [
                        SizedBox.square(
                          dimension: 75.r,
                          child: Lottie.asset("lottie/bulb.json"),
                        ),
                      ],
                      titleTextStyle: textTheme.displaySmall,
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      height: h_03 * 5.1,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: w_03 * 1.5),
                      child: const Clue(),
                    ),
                    for (Word word in notifier.riddle?.words ?? [])
                      EditableWord(word, height: h_03 * 2.85),
                    Gap(h_03 * 1.5),
                    const CustomKeyboard(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
