import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../logic/remote/pod.dart';

import 'theme/colors.dart';

class RenovationPage extends ConsumerWidget {
  const RenovationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String renovation = ref.watch(renovationProvider).value ?? "";
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: seaWhite,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Gap(150.r),
            FadeIn(
              delay: const Duration(milliseconds: 300),
              child: SizedBox.square(
                dimension: 480.r > 360.w ? 450.r : 480.r,
                child: Lottie.asset('lottie/under_construction.json'),
              ),
            ),
            //Gap(30.h),
            FadeIn(
              delay: const Duration(milliseconds: 600),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.r),
                child: AutoSizeText(
                  renovation.isEmpty ? "We will be back soon" : renovation,
                  style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
