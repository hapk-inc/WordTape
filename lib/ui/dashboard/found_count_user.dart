import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../logic/puzzle/bloc.dart';
import '../../theme/colors.dart';

class FoundCountUser extends ConsumerWidget {
  const FoundCountUser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final int foundCount = ref.watch(foundCountProvider).value ?? 0;
    return Container(
      height: 150.h,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.topRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AnimatedFlipCounter(
            value: foundCount,
            wholeDigits: 2,
            textStyle: textTheme.titleLarge?.copyWith(color: verdiGris),
          ),
          Text(
            "users played today",
            style: textTheme.bodyMedium?.copyWith(color: ashGray, height: 1.5),
          )
        ],
      ),
    );
  }
}
