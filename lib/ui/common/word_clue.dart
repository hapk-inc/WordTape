import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:toastification/toastification.dart';

import '../../function/question/notifier.dart';
import '../../panel/widget.dart';
import '../../theme/color.dart';

class WordClueState extends PanelWidget {
  final DateTime date;
  final ToastificationItem item;
  const WordClueState(this.date, this.item, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QuestionNotifier notifier = ref.watch(questionNotifierProvider(date));
    return Container(
      decoration: BoxDecoration(
        color: seaWhite,
        borderRadius: BorderRadius.circular(7.5.r),
      ),
      height: height(),
      child: Stack(
        children: [
          Positioned(
            top: 1.5.r,
            right: 1.5.r,
            child: IconButton(
              onPressed: () => toastification.dismiss(item),
              icon: const Icon(Icons.close),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.r),
            alignment: Alignment.centerLeft,
            child: FadeIn(
              delay: const Duration(milliseconds: 300),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Discipline is the best tool',
                    speed: const Duration(milliseconds: 90),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool backdropEnabled() => false;

  @override
  SlideDirection direction() => SlideDirection.DOWN;

  @override
  double height() => 150.r;
}
