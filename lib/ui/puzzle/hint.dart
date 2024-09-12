import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';

import '../../enum/pod.dart';
import '../../function/gen_ai/pod.dart';
import '../../function/logger/pod.dart';
import '../../function/puzzle/notifier.dart';
import '../../function/puzzle/pod.dart';
import '../../model/found.dart';

class PuzzleHint extends ConsumerWidget {
  const PuzzleHint({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ScreenSize size = ref.watch(sizeProvider);
    final bool isTab = size == ScreenSize.tab;

    final String recall = ref.read(recallNextProvider);

    final DateTime date = ref.read(selectedDateProvider);
    final PuzzleNotifier notifier = ref.watch(puzzleNotifierProvider(date));

    final Found found = notifier.found;

    //final String hint = notifier.hint;

    final String hint = notifier.hint ??
        (found.mistake == null
            ? ref.watch(createHintProvider(word: notifier.next)).maybeWhen(
                  data: (data) => data,
                  orElse: () => recall,
                  error: (error, _) {
                    return notifier.localHint ??
                        "Looks like you're own. $recall";
                  },
                )
            : ref
                .watch(helpUserProvider(
                    word: notifier.next, mistake: notifier.mistakeCombination))
                .maybeWhen(
                  data: (data) => data,
                  orElse: () => "Let me think",
                  error: (e, _) => "That's not correct. Use Hint button",
                ));

    return AnimatedSwitcher(
      duration: Duration.zero,
      transitionBuilder: (child, _) => child,
      child: FadeInUp(
        from: 15.h,
        delay: const Duration(milliseconds: 600),
        key: ValueKey(hint),
        child: AutoSizeText(
          hint,
          style: textTheme.bodyMedium?.copyWith(color: Colors.amber),
          maxLines: 2,
          stepGranularity: 3,
          minFontSize: 12,
          maxFontSize: isTab ? 24 : 21,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
