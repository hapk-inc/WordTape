import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../enum/enum.dart';
import '../../function/riddle/hint.dart';

import '../../extension/extension.dart';

class Clue extends ConsumerWidget {
  const Clue({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final DateTime date = DateTime.now().convert();
    String hint = ref.watch(hintProvider(date));
    final ScreenSize size = ref.watch(sizeProvider);
    final bool isTab = size == ScreenSize.tab;
    return AnimatedSwitcher(
      duration: Duration.zero,
      transitionBuilder: (child, _) => child,
      child: FadeInUp(
        from: 15.h,
        delay: const Duration(milliseconds: 600),
        key: ValueKey(hint),
        child: AutoSizeText(
          hint,
          style: textTheme.bodySmall?.copyWith(
            color: Colors.amber,
            height: 1.8,
          ),
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
