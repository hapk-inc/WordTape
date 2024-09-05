/*
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../function/auth/pod.dart';
import 'theme/colors.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: midnightGreen,
      child: LayoutBuilder(
        builder: (_, constraints) {
          final double mW = constraints.maxWidth;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: mW * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(90.r),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  alignment: Alignment.topLeft,
                  height: 120.h,
                  child: FadeIn(
                    duration: const Duration(milliseconds: 150),
                    delay: const Duration(milliseconds: 300),
                    child: const EnterName(),
                  ),
                ),
                const NameTextField(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NameTextField extends ConsumerWidget {
  const NameTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return TextField(
      showCursor: false,
      autofocus: true,
      style: textTheme.titleLarge?.copyWith(
        color: seaWhite,
        height: 2.1,
      ), // Text color
      onSubmitted: (value) => ref.read(userLoginProvider),
    );
  }
}

class EnterName extends StatelessWidget {
  const EnterName({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "First, let us know your ",
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: FadeIn(
                  duration: const Duration(milliseconds: 150),
                  delay: const Duration(milliseconds: 1200),
                  child: Text(
                    "name.",
                    style: textTheme.titleMedium?.copyWith(color: aquaMarine),
                  ),
                ),
              )
            ],
          )
        ],
        style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
      ),
    );
  }
}
*/
