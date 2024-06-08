import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../theme/colors.dart';
import 'dashboard/button_bar.dart';
import 'dashboard/puzzle_calendar.dart';

@RoutePage()
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PuzzleCalendar(),
          Gap(150.r),
          FadeIn(
            delay: const Duration(milliseconds: 300),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              title: Text(
                "WORDTAPE",
                style: textTheme.titleLarge?.copyWith(
                  color: engineeringOrange,
                  height: 1.5,
                ),
              ),
              subtitle: Text(
                "Challenging word puzzle game",
                style: textTheme.bodyMedium?.copyWith(
                  color: payneGray,
                  height: 1.5,
                ),
              ),
            ),
          ),
          Gap(30.r),
          const DashboardButtonBar()
        ],
      ),
    );
  }
}
