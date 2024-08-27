import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../logic/carousel_slider.dart';
import '../logic/puzzle_date.dart';
import '../logic/size.dart';

import 'dashboard/leaderboard.dart';
import 'dashboard/my_calendar.dart';
import 'dashboard/puzzle_tile.dart';
import 'theme/colors.dart';

@RoutePage()
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String size = ref.watch(sizeProvider);
    final CarouselSliderController carouselController =
        ref.read(carouselProvider);
    final int pCount = ref.read(puzzleCountProvider);
    return LayoutBuilder(
      builder: (_, constraint) {
        final double maxHeight = constraint.maxHeight;
        final double maxWidth = constraint.maxWidth;
        final double mW_15 = maxWidth * 0.015;
        final double mH_15 = maxHeight * 0.015;
        return SafeArea(
          child: ColoredBox(
            color: seaWhite,
            child: ListView(
              children: [
                Gap(mH_15),
                CarouselSlider(
                  carouselController: carouselController,
                  items: List.generate(
                    pCount,
                    (index) {
                      final DateTime chosenDate =
                          ref.read(puzzleDateProvider(index));
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: midnightGreen,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        height: maxHeight * (size != "pc" ? 0.7 : 0.84),
                        margin: EdgeInsets.symmetric(horizontal: mW_15),
                        padding: EdgeInsets.symmetric(horizontal: mW_15),
                        child: PuzzleTile(chosenDate),
                      );
                    },
                  ),
                  options: CarouselOptions(
                    initialPage: DateTime.now()
                        .difference(ref.watch(chosenDateProvider))
                        .inDays,
                    height: maxHeight * (size != "pc" ? 0.705 : 0.84),
                    viewportFraction: 1,
                    padEnds: false,
                    enableInfiniteScroll: false,
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                  ),
                ),
                if (size != "pc" && !kIsWeb) ...[
                  Gap(mH_15),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: maxHeight * 0.135,
                    child: const MyCalendar(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: mW_15),
                    child: Divider(
                      height: maxHeight * 0.06,
                      color: slateGray,
                      thickness: 0.45.r,
                    ),
                  ),
                  Gap(mH_15),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    height: maxHeight * 0.24,
                    margin: EdgeInsets.symmetric(horizontal: mW_15),
                    padding: EdgeInsets.symmetric(horizontal: mW_15),
                    child: const LeaderBoard(),
                  ),
                  Gap(mH_15),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
