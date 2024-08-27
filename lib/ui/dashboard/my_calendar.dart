import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../logic/carousel_slider.dart';
import '../../logic/puzzle_date.dart';
import '../../logic/selected_date.dart';
import '../../model/found.dart';
import '../../model/puzzle.dart';
import '../theme/colors.dart';

class MyCalendar extends ConsumerWidget {
  const MyCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime selectedDate = ref.watch(chosenDateProvider);
    final int puzzleCount = ref.read(puzzleCountProvider);
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 15.r),
      children: List.generate(
        puzzleCount,
        (index) {
          final DateTime date = ref.read(puzzleDateProvider(index));
          final bool isSelected = DateUtils.isSameDay(date, selectedDate);
          return CalendarTile(
            index,
            isSelected,
            onTap: () {
              ref.read(chosenDateProvider.notifier).state = date;
              ref.read(carouselProvider).jumpToPage(index);
            },
          );
        },
      ),
    );
  }
}

class CalendarTile extends ConsumerWidget {
  final int index;
  final bool isSelected;
  final GestureTapCallback? onTap;

  const CalendarTile(this.index, this.isSelected,
      {required this.onTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final DateTime june10 = DateTime(2024, 6, 10);
    final DateTime now = DateTime.now();
    final DateTime selectedDate = ref.read(puzzleDateProvider(index));
    final Puzzle? puzzle =
        ref.watch(selectedPuzzleProvider(selectedDate)).value;
    final Found? found = ref.read(selectedFoundProvider(selectedDate)).value;
    final int inDays = now.difference(june10).inDays;
    if (found != null && isSelected) log("Found in CalendarTile $found");

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      constraints: BoxConstraints(maxWidth: 90.r),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? raisinBlack : null,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: onTap,
        child: puzzle == null
            ? Placeholder(color: Colors.grey.shade300)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    found?.foundTrack(puzzle.words.length) ?? "-",
                    style: textTheme.displaySmall?.copyWith(
                      color: isSelected ? seaWhite : slateGray,
                      fontSize: 12.r,
                    ),
                    maxLines: 1,
                    maxFontSize: 12,
                    minFontSize: 9,
                    stepGranularity: 1.5,
                    textAlign: TextAlign.center,
                  ),
                  Gap(4.8.r),
                  Text(
                    "${inDays - index}".padLeft(2, '0'),
                    style: textTheme.displayMedium?.copyWith(
                      color: isSelected ? seaWhite : slateGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}
