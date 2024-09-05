import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../enum/pod.dart';
import '../../function/gen_ai/pod.dart';
import '../../function/puzzle/notifier.dart';
import '../../function/puzzle/pod.dart';

class PuzzleHint extends ConsumerWidget {
  const PuzzleHint({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ScreenSize size = ref.watch(sizeProvider);
    final bool isTab = size == ScreenSize.tab;

    final DateTime date = ref.read(selectedDateProvider);
    final PuzzleNotifier notifier = ref.watch(puzzleNotifierProvider(date));
    final String hint = notifier.hint ?? ref.read(recallNextProvider);

    return AnimatedSwitcher(
      duration: Duration.zero,
      transitionBuilder: (child, _) => child,
      child: FadeInUp(
        delay: const Duration(milliseconds: 600),
        key: ValueKey(hint),
        child: AutoSizeText(
          hint ?? "",
          style: textTheme.bodyMedium?.copyWith(color: Colors.amber),
          maxLines: 3,
          stepGranularity: 3,
          minFontSize: 15,
          maxFontSize: isTab ? 30 : 21,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
