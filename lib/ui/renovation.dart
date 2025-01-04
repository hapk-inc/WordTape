import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../model/underline_text.dart';
import '../theme/color.dart';

const UnderlineText _construction = UnderlineText(
  "We will be back soon.\nMeanwhile, try to decode above",
  focused: "decode above",
);

class RenovationPage extends ConsumerWidget {
  const RenovationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> words = _construction.text.split(' ');
    List<String> highlighter = (_construction.focused ?? "").split(' ');

    final TextTheme textTheme = Theme.of(context).textTheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: ghostWhite,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Gap(120.r),
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
                child: AutoSizeText.rich(
                  TextSpan(
                    children: [
                      for (String word in words)
                        TextSpan(
                          text: word + (word != words.last ? " " : ""),
                          style: highlighter.contains(word)
                              ? textTheme.titleMedium
                                  ?.copyWith(color: blackBean)
                              : null,
                        ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
