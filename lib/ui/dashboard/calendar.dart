/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../function/puzzle/pod.dart';
import '../theme/colors.dart';

class Calendar extends ConsumerWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime now = DateTime.now();
    final int difference = now.difference(ref.read(jun10Provider)).inDays;

    return ListView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 15.r),
      children: List.generate(
        difference,
        (index) {
          DateTime date = now.subtract(Duration(days: index));
          return CalendarTile(date);
        },
      ),
    );
  }
}

class CalendarTile extends ConsumerWidget {
  final DateTime date;
  const CalendarTile(this.date, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime selectedDate = ref.watch(selectedDateProvider);
    bool isSelected = DateUtils.isSameDay(date, selectedDate);
    final String month = DateFormat.MMM().format(date);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      constraints: BoxConstraints(maxWidth: 75.r),
      margin: EdgeInsets.symmetric(horizontal: 7.5.r),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? aquaMarine : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(7.5.r),
      ),
      child: InkWell(
        onTap: () => ref.read(selectedDateProvider.notifier).state = date,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                month.toUpperCase(),
                style: textTheme.bodySmall?.copyWith(
                  color: isSelected ? raisinBlack : slateGray,
                  fontSize: 12.r,
                ),
              ),
              Gap(4.5.r),
              Text(
                "${date.day}".padLeft(2, '0'),
                style: textTheme.labelMedium?.copyWith(
                  color: isSelected ? raisinBlack : slateGray,
                  fontSize: 30.r,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
*/
