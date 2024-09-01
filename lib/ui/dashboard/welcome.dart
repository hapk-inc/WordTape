import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../enum/pod.dart';
import '../../model/welcome.dart';
import '../theme/colors.dart';

class WelcomeText extends ConsumerWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime now = DateTime.now();
    final Welcome text = ref.read(welcomeProvider(now.day));
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ScreenSize size = ref.watch(sizeProvider);

    return AutoSizeText.rich(
      TextSpan(
        children: [
          TextSpan(
            children: [
              TextSpan(text: text.text),
              if (size != ScreenSize.mobile) TextSpan(text: text.sub),
              TextSpan(
                text: text.end,
                style: textTheme.titleLarge?.copyWith(color: aquaMarine),
              )
            ],
          )
        ],
      ),
      maxLines: 2,
      style: textTheme.bodyLarge?.copyWith(color: seaWhite, height: 1.8),
      textAlign: TextAlign.center,
    );
  }
}
