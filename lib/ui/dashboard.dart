import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:mock_data/mock_data.dart';

import '../logic/panel_controller.dart';
import '../logic/size.dart';
import 'theme/colors.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraint) {
        //final double maxWidth = constraint.maxWidth;
        final double maxHeight = constraint.maxHeight;
        return SafeArea(
          child: ListView(
            children: [
              Gap(maxHeight * 0.015),
              AnimatedContainer(
                duration: const Duration(milliseconds: 750),
                decoration: BoxDecoration(
                  color: midnightGreen,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                height: maxHeight * (size != "pc" ? 0.675 : 0.9),
                margin: EdgeInsets.symmetric(horizontal: 7.5.r),
                padding: EdgeInsets.symmetric(horizontal: 7.5.r),
                child: const PuzzleTile(),
              ),
              if (size != "pc") ...[
                Gap(15.r),
                const MyCalendar(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.r),
                  child: Divider(
                    height: 60.r,
                    color: slateGray,
                    thickness: 0.75.r,
                  ),
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}

class PuzzleTile extends StatelessWidget {
  const PuzzleTile({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (_, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double maxHeight = constraints.maxHeight;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(maxHeight * (size == 'mobile' ? 0.075 : 0.12)),
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
              Gap(maxHeight * 0.075),
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
                            //backgroundColor:
                            //    WidgetStatePropertyAll(raisinBlack),
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
                        child: const Text("Share puzzle"),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(maxHeight * 0.075),
              const TodayCount(),
              Gap(maxHeight * 0.15),
              /*Container(
                padding: EdgeInsets.symmetric(
                  horizontal: maxWidth * 0.045,
                ),
                alignment: Alignment.centerRight,
                child: Text(
                  "17 AUGUST 2024",
                  style: textTheme.displaySmall,
                ),
              )*/
            ],
          ),
        );
      },
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
          padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.045),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedFlipCounter(
                value: count,
                wholeDigits: 2,
                padding: EdgeInsets.zero,
                textStyle: textTheme.displayLarge,
                //textStyle: textTheme.labelLarge?.copyWith(color: mint),
                duration: const Duration(milliseconds: 1200),
              ),
              Gap(7.5.r),
              Text("Users Played today", style: textTheme.displaySmall),
            ],
          ),
        );
      },
    );
  }
}

class MyCalendar extends StatelessWidget {
  const MyCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final DateTime now = DateTime.now();
    final DateTime randomDate =
        mockDate(now.subtract(Duration(days: mockInteger(1, 3))), now);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 105.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 15.r),
        children: List.generate(
          9,
          (index) {
            final DateTime now = DateTime.now();
            final DateTime date = now.copyWith(day: now.day - index);
            final bool isSelected = date.day == randomDate.day;
            final String week = DateFormat('EEE').format(date);
            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: EdgeInsets.symmetric(horizontal: 18.r),
              margin: EdgeInsets.symmetric(horizontal: 1.5.r),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? raisinBlack : null,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    week.toUpperCase(),
                    style: textTheme.displaySmall?.copyWith(
                      color: isSelected ? seaWhite : slateGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gap(3.r),
                  Text(
                    date.day.toString().padLeft(2, '0'),
                    style: textTheme.displayMedium?.copyWith(
                      color: isSelected ? seaWhite : slateGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
