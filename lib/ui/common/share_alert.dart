import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

import '../../enum/enum.dart';
import '../../function/underline_text/pod.dart';
import '../../theme/color.dart';

class ShareAlert extends ConsumerWidget {
  const ShareAlert({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String str = ref.read(passTextProvider);
    final String detail = ref.read(passTextDetailProvider);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: seaWhite,
      width: 540.r,
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
              maxLines: 1,
            ),
            Gap(6.r),
            AutoSizeText(
              "$detail Tap down",
              style: textTheme.bodySmall?.copyWith(color: Colors.grey),
              maxLines: ref.watch(sizeProvider) == ScreenSize.mobile ? 2 : 1,
            ),
            Center(
              child: SizedBox.square(
                dimension: 300.r,
                child: InkWell(
                  onTap: () => Share.share("xyz"),
                  child: Lottie.asset('lottie/share.json'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
