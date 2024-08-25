import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../logic/size.dart';

import 'dashboard/my_calendar.dart';
import 'dashboard/puzzle_tile.dart';
import 'theme/colors.dart';

@RoutePage()
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String size = ref.watch(sizeProvider);
    return LayoutBuilder(
      builder: (_, constraint) {
        final double maxHeight = constraint.maxHeight;
        final double maxWidth = constraint.maxWidth;
        return SafeArea(
          child: ColoredBox(
            color: seaWhite,
            child: ListView(
              children: [
                Gap(maxHeight * 0.015),
                CarouselSlider(
                  //disableGesture: true,
                  items: List.generate(
                    6,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: midnightGreen,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      height: maxHeight * (size != "pc" ? 0.705 : 0.84),
                      margin:
                          EdgeInsets.symmetric(horizontal: maxWidth * 0.018),
                      padding:
                          EdgeInsets.symmetric(horizontal: maxWidth * 0.015),
                      child: const PuzzleTile(),
                    ),
                  ),
                  options: CarouselOptions(
                    initialPage: 0,
                    height: maxHeight * (size != "pc" ? 0.705 : 0.84),
                    viewportFraction: 1,
                    padEnds: false,
                    enableInfiniteScroll: false,
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                  ),
                ),
                if (size != "pc") ...[
                  Gap(maxHeight * 0.015),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: maxHeight * 0.12,
                    child: const MyCalendar(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.015),
                    child: Divider(
                      height: maxHeight * 0.06,
                      color: slateGray,
                      thickness: 0.45.r,
                    ),
                  ),
                  Gap(maxHeight * 0.015),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
