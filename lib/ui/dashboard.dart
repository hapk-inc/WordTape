import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mock_data/mock_data.dart';

import '../logic/panel_controller.dart';
import '../logic/size.dart';
import 'theme/colors.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 750),
      decoration: BoxDecoration(
        color: midnightGreen,
        borderRadius: BorderRadius.circular(15.r),
      ),
      height: size == "mobile" ? 720.h : 750.h,
      margin: EdgeInsets.symmetric(horizontal: 7.5.r),
      padding: EdgeInsets.symmetric(horizontal: 7.5.r),
      child: LayoutBuilder(
        builder: (_, constraints) {
          final double maxWidth = constraints.maxWidth;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(size == 'mobile' ? 60.r : 120.r),
                AnimatedPadding(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.03),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Uncover hidden words in this"
                              "${size != "mobile" ? " fun and " : " "}"
                              "engaging ",
                          children: [
                            TextSpan(
                              text: "puzzle.",
                              style: textTheme.titleMedium?.copyWith(
                                color: seaWhite,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    style: textTheme.bodyLarge?.copyWith(color: seaWhite),
                  ),
                ),
                Gap(30.r),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: maxWidth * 0.03),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(raisinBlack),
                          ),
                          onPressed: () {
                            debugPrint("PLAY NOW");
                            switch (size) {
                              case "mobile":
                                {
                                  if (panelController.isPanelClosed) {
                                    panelController.open();
                                  }
                                  return;
                                }
                              default:
                                {}
                            }
                          },
                          child: const Text("Play Now"),
                        ),
                        SizedBox(width: maxWidth * 0.03),
                        OutlinedButton(
                          onPressed: () {},
                          style: const ButtonStyle(
                            foregroundColor: WidgetStatePropertyAll(seaWhite),
                            side: WidgetStatePropertyAll(
                              BorderSide(color: slateGray),
                            ),
                          ),
                          child: const Text("Share this puzzle"),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(60.r),
                const TodayCount(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TodayCount extends StatelessWidget {
  const TodayCount({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final int count = mockInteger(1, 30);
    return LayoutBuilder(
      builder: (_, constraint) {
        final double maxWidth = constraint.maxWidth;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedFlipCounter(
                value: count,
                wholeDigits: 2,
                padding: EdgeInsets.zero,
                textStyle: textTheme.labelLarge?.copyWith(color: mint),
                duration: const Duration(milliseconds: 1200),
              ),
              Gap(7.5.r),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.003),
                child: Text(
                  "Users Played today",
                  style: textTheme.labelMedium?.copyWith(color: mint),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
