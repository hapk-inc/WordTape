import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../model/welcome.dart';
import '../theme/color.dart';

class ShareDialog extends ConsumerWidget {
  const ShareDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String str = ref.read(passTextProvider);
    final String sub = ref.read(passDetailProvider);
    return ColoredBox(
      color: seaWhite,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(15.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              str,
              style: textTheme.bodyLarge?.copyWith(
                color: blackBean,
                fontSize: 30.r,
              ),
              maxLines: 1,
            ),
            Text("$sub Tap down", style: textTheme.bodySmall),
            Center(
              child: SizedBox.square(
                dimension: 240.r,
                child: InkWell(
                  onTap: () {},
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
