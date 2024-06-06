import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../logic/puzzle/found_notifier.dart';
import '../../model/found.dart';
import '../../theme/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'create_account.dart';

class ReLoginDialog extends ConsumerWidget {
  const ReLoginDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Found? found = ref.watch(foundNotifierProvider).value;
    return Container(
      width: 540.r,
      height: 360.r,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 15.r),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText.rich(
              TextSpan(
                children: [
                  if (found?.isCompleted ?? false)
                    const TextSpan(
                      text: "Congratulations on completing today's game! ",
                    ),
                  const TextSpan(text: "Create your profile now to:"),
                ],
              ),
              style: textTheme.titleMedium?.copyWith(
                color: payneGray,
                height: 1.8,
              ),
              maxLines: 2,
            ),
            Gap(7.5.h),
            const AutoSizeText.rich(
              TextSpan(
                children: [
                  TextSpan(text: "Access and play previous puzzles\n"),
                  TextSpan(text: "View your stats \n"),
                  TextSpan(
                    text: "Suggest a puzzle that might be "
                        "featured as daily challenge\n",
                  )
                ],
                style: TextStyle(color: slateGray, height: 2.1),
              ),
            ),
            const ButtonBar(
              buttonPadding: EdgeInsets.zero,
              children: [CreateAccount()],
            )
          ],
        ),
      ),
    );
  }
}
