import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/size.dart';
import '../../logic/welcome_text.dart';
import '../../model/puzzle.dart';
import '../theme/colors.dart';

class Welcome extends ConsumerWidget {
  final Puzzle? puzzle;
  const Welcome(this.puzzle, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String size = ref.watch(sizeProvider);
    final WelcomeText welcomeText =
        ref.read(welcomeTextProvider(puzzle?.puzzleNo ?? 0));
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            children: [
              if (puzzle != null) ...[
                TextSpan(text: welcomeText.text),
                if (size != "mobile") TextSpan(text: welcomeText.sub),
              ] else ...[
                const TextSpan(text: "No ")
              ],
              TextSpan(
                text: "puzzle.",
                style: textTheme.titleMedium?.copyWith(color: aquaMarine),
              )
            ],
          )
        ],
      ),
      style: textTheme.labelMedium?.copyWith(color: seaWhite),
    );
  }
}
