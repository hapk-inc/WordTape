import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'theme/colors.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextEditingController controller = TextEditingController();
    return Scaffold(
      backgroundColor: midnightGreen,
      body: LayoutBuilder(
        builder: (_, constraints) {
          final double mW = constraints.maxWidth;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.r),
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
                    child: Text.rich(
                      TextSpan(
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
                                    style: textTheme.titleSmall?.copyWith(
                                      color: aquaMarine,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      style: textTheme.labelMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
                FadeIn(
                  delay: const Duration(milliseconds: 2400),
                  child: Padding(
                    padding: EdgeInsets.only(left: mW * 0.015),
                    child: TextField(
                      controller: controller,
                      style: textTheme.titleMedium?.copyWith(color: aquaMarine),
                      showCursor: false,
                      autofocus: true,
                      onSubmitted: (value) => log(value),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
