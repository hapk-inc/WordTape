import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/welcome.dart';
import '../theme/colors.dart';

class WelcomeText extends ConsumerWidget {
  final Welcome sentence;
  const WelcomeText(this.sentence, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final Welcome sentence = ref.read(welcomeProvider);
    List<String> words = sentence.text.split(' ');
    List<String> highlighter = (sentence.highlight ?? "").split(' ');
    final TextTheme textTheme = Theme.of(context).textTheme;

    return FadeInUp(
      delay: const Duration(milliseconds: 600),
      key: ValueKey(sentence),
      child: AutoSizeText.rich(
        TextSpan(
          children: [
            for (String word in words)
              TextSpan(
                text: word + (word != words.last ? " " : ""),
                style: highlighter.contains(word)
                    ? textTheme.titleLarge?.copyWith(color: aquaMarine)
                    : null,
              ),
            TextSpan(
              text: sentence.end,
              style: words.last == highlighter.last
                  ? textTheme.titleLarge?.copyWith(color: aquaMarine)
                  : null,
            )
          ],
        ),
        maxLines: 2,
        style: textTheme.bodyLarge?.copyWith(color: seaWhite, height: 1.8),
        textAlign: TextAlign.center,
      ),
    );
  }
}
