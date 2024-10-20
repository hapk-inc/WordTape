import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../extension/extension.dart';

import '../../function/question/notifier.dart';
import '../../model/prompt.dart';

class RiddleClue extends ConsumerWidget {
  const RiddleClue({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime date = DateTime.now().convert();
    final Prompt prompt = ref.watch(questionNotifierProvider(date)).prompt;

    return AnimatedSwitcher(
      duration: Duration.zero,
      transitionBuilder: (child, _) => child,
      child: FadeInUp(
        from: 15.h,
        delay: const Duration(milliseconds: 600),
        key: ValueKey(prompt),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 600),
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.amber),
          child: AutoSizeText(
            prompt.text.text,
            maxLines: 2,
            presetFontSizes: [21.r, 18.r, 15.r, 12.r],
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
