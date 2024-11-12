import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Logo extends ConsumerWidget {
  final void Function(AnimateDoDirection)? onFinish;

  const Logo({this.onFinish, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.5.r),
      alignment: Alignment.center,
      child: FadeIn(
        duration: const Duration(milliseconds: 300),
        delay: const Duration(milliseconds: 750),
        onFinish: onFinish,
        child: AutoSizeText(
          "WORDTAPE",
          textAlign: TextAlign.center,
          style: textTheme.displayLarge?.copyWith(fontSize: 72.r),
          maxLines: 1,
          presetFontSizes: [72.r, 60.r, 54.r],
        ),
      ),
    );
  }
}
