import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../function/question/notifier.dart';
import '../../theme/color.dart';
import 'typewriter_text.dart';

const Duration _m4500 = Duration(milliseconds: 4500);

class WordClueState extends ConsumerWidget {
  final DateTime date;
  const WordClueState(this.date, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QuestionNotifier notifier = ref.watch(questionNotifierProvider(date));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 15.r, vertical: 15.r),
      decoration: BoxDecoration(
        color: seaWhite,
        borderRadius: BorderRadius.circular(7.5.r),
      ),
      height: 135.r,
      child: Stack(
        children: [
          Positioned(
            top: 1.5.r,
            right: 1.5.r,
            child: IconButton(
              onPressed: () => notifier.typing = false,
              icon: const Icon(Icons.close),
            ),
          ),
          Positioned(
            top: 30.r,
            right: 30.r,
            left: 15.r,
            bottom: 15.r,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: notifier.clue.isEmpty
                  ? SizedBox.square(
                      dimension: 90.r,
                      child: Lottie.asset('lottie/loading.json'),
                    )
                  : Container(
                      alignment: Alignment.topLeft,
                      child: FadeIn(
                        duration: const Duration(milliseconds: 600),
                        key: ValueKey(notifier.clue),
                        child: TypewriterText(
                          notifier.clue,
                          onEnd: () async {
                            await Future.delayed(_m4500);
                            notifier.typing = false;
                          },
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
