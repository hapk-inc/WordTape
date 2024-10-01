import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliding_up_panel/src/panel.dart';

import '../../enum/enum.dart';
import '../../function/underline_text/pod.dart';
import '../../panel/widget.dart';
import '../../theme/color.dart';
import '../../theme/pod.dart';

class NotifyAndShare extends PanelWidget {
  const NotifyAndShare({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String str = ref.read(passPromptProvider);
    final String detail = ref.read(passPromptDetailProvider);
    final ScreenSize size = ref.watch(sizeProvider);
    final bool isDialog = size != ScreenSize.mobile;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isDialog ? 360.r : height(),
      decoration: BoxDecoration(
        gradient: ref.read(gradientProvider(color: [seaWhite, azureGreen])),
      ),
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 30.r),
      constraints: BoxConstraints(maxWidth: 540.r),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              str,
              style: textTheme.bodyLarge?.copyWith(
                color: blackBean,
                height: 0,
              ),
            ),
            Gap(4.5.r),
            AutoSizeText(
              detail,
              style: textTheme.bodySmall?.copyWith(color: Colors.grey),
              minFontSize: 10.5,
              maxFontSize: 15,
              stepGranularity: 1.5,
              maxLines: isDialog ? 1 : null,
            ),
            Center(
              child: FadeIn(
                delay: const Duration(milliseconds: 750),
                child: SizedBox.square(
                  dimension: 270.r,
                  child: InkWell(
                    onTap: () => Share.share("xyz"),
                    child: Lottie.asset('lottie/share.json'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double height() => 360.r;

  @override
  SlideDirection direction() => SlideDirection.UP;
}
