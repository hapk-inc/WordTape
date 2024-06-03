import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../theme/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'create_account.dart';

class ReLoginDialog extends StatelessWidget {
  const ReLoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      // height: 450.r,
      width: 540.r,
      height: 360.r,

      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.r),
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(15.h),
            AutoSizeText(
              "Congratulations on completing today's game! Create your profile now to:",
              style: textTheme.titleMedium
                  ?.copyWith(color: payneGray, height: 1.8),
              maxLines: 2,
            ),
            Gap(15.h),
            Text("Access and play previous puzzles", style: _subFont),
            Gap(7.5.h),
            Text("View your stats", style: _subFont),
            Gap(7.5.h),
            Text(
              "Suggest a puzzle that might be featured as daily challenge",
              style: _subFont,
            ),
            Gap(30.h),
            const ButtonBar(children: [CreateAccount()])
          ],
        ),
      ),
    );
  }
}

TextStyle get _subFont => const TextStyle(
      color: slateGray,
      height: 1.8,
    );

/*  */
