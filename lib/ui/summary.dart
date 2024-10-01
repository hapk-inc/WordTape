import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:mock_data/mock_data.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:wordtape/panel/widget.dart';

import '../enum/enum.dart';
import '../theme/color.dart';

class SummaryPage extends PanelWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ScreenSize size = ref.watch(sizeProvider);
    final bool isDialog = size != ScreenSize.mobile;
    return Container(
      color: seaWhite,
      child: SafeArea(
        child: Stack(
          children: [
            Lottie.asset('lottie/confetti.json', repeat: true),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox.square(
                    dimension: 150.r,
                    child: Lottie.asset('lottie/trophy.json', fit: BoxFit.fill),
                  ),
                  Gap(30.r),
                  Text(
                    "Better luck next time",
                    style: textTheme.bodyLarge
                        ?.copyWith(color: blackBean, height: 1.8),
                  ),
                  AutoSizeText(
                    mockString(30),
                    style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                    minFontSize: 12,
                    maxFontSize: 15,
                    stepGranularity: 1.5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  SlideDirection direction() => SlideDirection.DOWN;

  @override
  double height() => 480.r;
}
