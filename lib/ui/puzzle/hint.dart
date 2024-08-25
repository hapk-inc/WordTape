import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mock_data/mock_data.dart';

import '../../logic/gemini_ai.dart';
import '../theme/colors.dart';

class PuzzleHint extends ConsumerWidget {
  const PuzzleHint({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return ref.watch(randomTextProvider(word: "")).maybeWhen(
          orElse: () => Container(),
          error: (error, stackTrace) => AutoSizeText(
            "Try to find the next word",
            style: textTheme.bodyMedium?.copyWith(color: midnightGreen),
            maxLines: 3,
            stepGranularity: 1.5,
            minFontSize: 12,
            maxFontSize: 21,
          ),
          data: (data) => AutoSizeText(
            data.text ?? mockString(45),
            style: textTheme.bodyMedium?.copyWith(color: midnightGreen),
            maxLines: 3,
            stepGranularity: 1.5,
            minFontSize: 12,
            maxFontSize: 21,
          ),
        );
  }
}
