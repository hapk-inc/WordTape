import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../function/question/notifier.dart';
import '../../function/question/toast.dart';
import '../../theme/color.dart';
import 'typewriter_text.dart';

// const Duration _m4500 = Duration(milliseconds: 4500);

class RiddleToast extends ConsumerWidget {
  final DateTime date;
  const RiddleToast(this.date, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? toastText =
        ref.watch(questionNotifierProvider(date)).toastText;
    return Material(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        child: Container(
          decoration: BoxDecoration(
            color: azureGreen,
            borderRadius: BorderRadius.circular(7.5.r),
          ),
          height: 135.r,
          alignment: Alignment.center,
          child: Stack(
            children: [
              Positioned.fill(
                left: null,
                child: AnimatedOpacity(
                  opacity: 0.36,
                  duration: const Duration(milliseconds: 300),
                  child: SizedBox.square(
                    dimension: 120.r,
                    child: Lottie.asset("question_lottie".tr()),
                  ),
                ),
              ),
              Positioned.fill(
                right: 45.r,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: RiddleToastState(toastText),
                ),
              ),
              Positioned(
                right: 7.5.r,
                top: 7.5.r,
                child: _ToastCloseButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToastCloseButton extends ConsumerWidget {
  const _ToastCloseButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) => InkWell(
        onTap: () => ref.read(toastNotifierProvider.notifier).dismiss(),
        child: Icon(Icons.close, color: midnightGreen),
      );
}

class RiddleToastState extends StatelessWidget {
  final String? text;
  const RiddleToastState(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 30.r),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: text == null
              ? SizedBox()
              : TypewriterText(
                  text!,
                  onEnd: () {},
                ),
        ),
      );
}

/*class WordClueState extends ConsumerWidget {
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
              child: notifier.riddleClue.isEmpty
                  ? SizedBox.square(
                      dimension: 90.r,
                      child: Lottie.asset('lottie/loading.json'),
                    )
                  : Container(
                      alignment: Alignment.topLeft,
                      child: FadeIn(
                        duration: const Duration(milliseconds: 600),
                        key: ValueKey(notifier.riddleClue),
                        child: TypewriterText(
                          notifier.riddleClue,
                          onEnd: () async {
                            await Future.delayed(_m4500);
                            notifier.typing = false;
                          },
                        ),
                      ),
                    ),
            ),
          ),
          // Positioned(child: child)
        ],
      ),
    );
  }
}*/
