import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../theme/color.dart';
import 'light_btn.dart';

class PuzzleAppBar extends StatelessWidget {
  const PuzzleAppBar({required this.height, super.key});

  final double height;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return AppBar(
      toolbarHeight: height,
      actions: const [LightBtn()],
      titleTextStyle: textTheme.displaySmall?.copyWith(color: seaWhite),
      title: FadeIn(
        delay: const Duration(milliseconds: 750),
        child: const Text("WORDTAPE"),
      ),
    );
  }
}
