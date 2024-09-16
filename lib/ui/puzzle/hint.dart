import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../enum/pod.dart';
import '../../function/puzzle/hint.dart';
import '../../function/puzzle/pod.dart';

class PuzzleHint extends ConsumerStatefulWidget {
  const PuzzleHint({super.key});

  @override
  ConsumerState createState() => _PuzzleHintState();
}

class _PuzzleHintState extends ConsumerState<PuzzleHint> {
  late DateTime date;
  late String hint;

  @override
  void initState() {
    date = ref.read(selectedDateProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ScreenSize size = ref.watch(sizeProvider);
    final bool isTab = size == ScreenSize.tab;
    hint = ref.watch(hintNotifierProvider(date));

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
