import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../function/question/notifier.dart';
import '../../function/question/toast.dart';
import '../../model/word.dart';
import '../../theme/color.dart';
import '../../theme/pod.dart';
import 'typewriter_text.dart';

// const Duration _m4500 = Duration(milliseconds: 4500);

class RiddleToast extends ConsumerWidget {
  final DateTime date;
  final Word? word;
  const RiddleToast(this.date, {super.key, this.word});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? toastText =
        ref.watch(questionNotifierProvider(date)).toastText;
    return Material(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        child: Container(
          decoration: BoxDecoration(color: ghostWhite),
          height: 144.r,
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
                  child: RiddleToastState(toastText, date),
                ),
              ),
              Positioned(
                right: 7.5.r,
                top: 7.5.r,
                child: _ToastCloseButton(
                  onTap: () {
                    ref.read(questionNotifierProvider(date)).toastText = null;
                    ref.read(toastNotifierProvider.notifier).dismiss();
                    /*if (word != null) {
                      ref.read(wordNotifierProvider(word!)).node.requestFocus();
                    }*/
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToastCloseButton extends ConsumerWidget {
  final GestureTapCallback? onTap;
  const _ToastCloseButton({this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) => InkWell(
        onTap: onTap,
        child: Icon(Icons.close, color: midnightGreen),
      );
}

class RiddleToastState extends ConsumerWidget {
  final String? text;
  final DateTime date;
  const RiddleToastState(this.text, this.date, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        constraints: BoxConstraints.expand(),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(15.r),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: text == null
              ? null
              : TypewriterText(
                  text!,
                  onEnd: () {},
                  color: ref.read(customThemeProvider(date.day)).forToday[1],
                ),
        ),
      );
}
