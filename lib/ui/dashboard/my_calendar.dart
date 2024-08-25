import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mock_data/mock_data.dart';

import '../../logic/selected_date.dart';
import '../theme/colors.dart';

class MyCalendar extends ConsumerWidget {
  const MyCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final DateTime selectedDate = ref.watch(selectedDateNotifierProvider).date;
    final DateTime now = DateTime.now();
    final DateTime june10 = DateTime(2024, 6, 10);
    final int inDays = now.difference(june10).inDays;
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 15.r),
      children: List.generate(
        inDays,
        (index) {
          final DateTime date = now.copyWith(day: now.day - index);
          final bool isSelected = DateUtils.isSameDay(date, selectedDate);
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            constraints: BoxConstraints(maxWidth: 90.r),
            //padding: EdgeInsets.symmetric(horizontal: 15.r),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? raisinBlack : null,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: InkWell(
              onTap: () {
                ref.read(selectedDateNotifierProvider).date = date;
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    //week.toUpperCase(),
                    //"DONE",
                    ["DONE", "PENDING", "-"][mockInteger(0, 2)],
                    // "",
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
                  Gap(1.5.r),
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
        },
      ),
    );
  }
}
