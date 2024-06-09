import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../logic/app/bloc.dart';
import '../../logic/auth/bloc.dart';
import '../../router/my_route.dart';
import '../../theme/colors.dart';

class SubscribeDialog extends ConsumerWidget {
  const SubscribeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("16--");

    return Stack(
      children: [
        Container(
          constraints: BoxConstraints.expand(width: 450.r),
          padding: EdgeInsets.symmetric(horizontal: 30.r),
          child: const CongratulationDialog(),
        )
      ],
    );
  }
}

class CongratulationDialog extends ConsumerWidget {
  const CongratulationDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Gap(30.h),
        const Expanded(flex: 14, child: LoginDialog()),
        const Spacer(),
        ...[
          Divider(height: 45.h, color: ashGray, thickness: 0.45.r),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(text: "By signing in, you agree to "),
                TextSpan(
                  text: "Privacy Policy",
                  style: const TextStyle(color: teal),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      ref.read(panelControllerProvider).close();
                      context.router.push(const PrivacyPolicyRoute());
                    },
                )
              ],
              style: textTheme.bodySmall?.copyWith(color: ashGray),
            ),
          ),
        ],
        Gap(30.h),
      ],
    );
  }
}

class LoginDialog extends ConsumerWidget {
  const LoginDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (_, constraint) {
        final double mH = constraint.maxHeight;
        final double mW = constraint.maxWidth;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              "Subscribe Now",
              style: textTheme.titleMedium?.copyWith(color: teal, height: 2.1),
            ),
            AutoSizeText(
              "Access and play previous puzzles. View your stats.",
              style: textTheme.bodySmall?.copyWith(color: ashGray),
              maxLines: 1,
            ),
            Gap(15.h),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: mW * 0.036),
                        ),
                      ),
                      onPressed: () => ref.read(googleLoginProvider),
                      child: Image.asset(
                        'images/google-logo.png',
                        height: mH * 0.18,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
