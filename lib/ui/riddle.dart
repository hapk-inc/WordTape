import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import '../function/key_tap/pod.dart';
import '../function/riddle/notifier.dart';
import '../model/word.dart';
import 'common/custom_keyboard.dart';
import 'common/editable_word.dart';
import 'common/gradient_box.dart';
import 'common/clue.dart';

class RiddlePage extends ConsumerWidget {
  final DateTime date;
  const RiddlePage(this.date, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final RiddleNotifier notifier = ref.watch(riddleNotifierProvider(date));

    //
    return GradientBox(
      child: SafeArea(
        bottom: false,
        child: KeyboardListener(
          focusNode: notifier.activeNode,
          autofocus: true,
          onKeyEvent: (KeyEvent? value) {
            if (value is KeyDownEvent || value is KeyRepeatEvent) {
              ref.read(keyTapNotifierProvider.notifier).state = value;
            }
          },
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
                        actions: const [LottieHint()],
                        titleTextStyle: textTheme.displaySmall,
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        height: h_03 * 5.4,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: w_03 * 1.5),
                        child: const Clue(),
                      ),
                      for (Word word in notifier.riddle?.words ?? [])
                        EditableWord(word),
                      Gap(h_03 * 1.5),
                      const CustomKeyboard(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class LottieHint extends StatelessWidget {
  const LottieHint({super.key});

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: 75.r,
        child: Lottie.asset("lottie/bulb.json"),
      );
}
