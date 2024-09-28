import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../function/riddle/riddle_hint.dart';
import '../../model/date_ext.dart';

import '../../enum/enum.dart';

class Clue extends ConsumerWidget {
  const Clue({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final DateTime date = DateTime.now().convert();
    String hint = ref.watch(riddleHintProvider(date));
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
          style: textTheme.bodySmall?.copyWith(color: Colors.amber),
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
