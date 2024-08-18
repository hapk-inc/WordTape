import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'theme/colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: midnightGreen,
      body: LayoutBuilder(
        builder: (_, constraints) {
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
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "First, let us know your ",
                          children: [
                            TextSpan(
                              text: "name.",
                              style: textTheme.titleSmall?.copyWith(
                                color: aquaMarine,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    style: textTheme.labelMedium?.copyWith(color: seaWhite),
                  ),
                ),
                //Gap(30.r),
                TextField(
                  style: textTheme.titleMedium?.copyWith(color: aquaMarine),
                  showCursor: false,
                ),
                /*Gap(60.r),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: maxWidth * 0.03),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("Start Now"),
                      ),
                    ],
                  ),
                ),
                Gap(60.r),*/
              ],
            ),
          );
        },
      ),
    );
  }
}
