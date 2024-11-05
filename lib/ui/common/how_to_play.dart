import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../function/underline_text/pod.dart';
import '../../model/underline_text.dart';
import '../../panel/widget.dart';
import '../../theme/color.dart';
import '../../theme/font.dart';
import '../../theme/pod.dart';

class HowToPlay extends PanelWidget {
  const HowToPlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DefaultTextTheme defaultTextTheme = DefaultTextTheme();
    final List<UnderlineText> list = ref.read(howPlayProvider);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: height(),
      decoration: BoxDecoration(
        gradient: ref.read(gradientProvider(color: [seaWhite, azureGreen])),
      ),
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(15.r),
      constraints: BoxConstraints(maxWidth: 540.r),
      child: FadeIn(
        delay: const Duration(milliseconds: 300),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  "How to Play",
                  style: defaultTextTheme.headlineLarge,
                ),
                Gap(1.5.r),
                RichText(
                  text: TextSpan(
                    children: <InlineSpan>[
                      for (UnderlineText underline in list)
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "⚫️",
                              style: defaultTextTheme.emojiSmall.copyWith(
                                fontSize: 4.5.r,
                              ),
                            ),
                            const TextSpan(text: "  "),
                            TextSpan(text: underline.text),
                            const TextSpan(text: "\n")
                          ],
                        )
                    ],
                    style:
                        defaultTextTheme.bodySmall?.copyWith(color: cadetGray),
                  ),
                ),
                Center(
                  child: FadeInUp(
                    delay: const Duration(milliseconds: 750),
                    child: SizedBox.square(
                      dimension: 300.r,
                      child: Lottie.asset('lottie/share.json'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  double height() => 600.r;

  @override
  SlideDirection direction() => SlideDirection.UP;

  @override
  bool backdropEnabled() => true;
}

/*TextSpan _pts(String title, String sub) => TextSpan(
      text: title,
      children: [
        const TextSpan(text: " : "),
        TextSpan(text: sub, style: const TextStyle(color: slateGray))
      ],
    );*/
