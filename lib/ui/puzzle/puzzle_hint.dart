import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/gemini_ai.dart';
import '../theme/colors.dart';

class PuzzleHint extends ConsumerWidget {
  final String id;
  const PuzzleHint(this.id, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String hint = ref.watch(puzzleHintProvider(id)).value ?? "";
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AnimatedSwitcher(
      duration: Duration.zero,
      transitionBuilder: (child, _) => child,
      child: FadeIn(
        delay: const Duration(milliseconds: 750),
        key: ValueKey(hint),
        child: AutoSizeText(
          hint,
          style: textTheme.bodyMedium?.copyWith(color: slateGray),
          maxLines: 3,
          stepGranularity: 1.5,
          minFontSize: 12,
          maxFontSize: 21,
        ),
      ),
    );
  }
}
