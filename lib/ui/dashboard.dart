import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../logic/app/bloc.dart';
import '../theme/colors.dart';
import 'dashboard/button_bar.dart';
import 'dashboard/found_count_user.dart';
import 'dashboard/puzzle_calendar.dart';

@RoutePage()
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    //final Player? player = ref.watch(playerProvider).value;
    //debugPrint("24--$player");
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PuzzleCalendar(),
              const FoundCountUser(),
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
                      color: slateGray,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              Gap(30.r),
              const DashboardButtonBar()
            ],
          ),
        ),
        Positioned(
          bottom: 30.r,
          left: 15.r,
          child: ref.watch(packageProvider).maybeWhen(
                data: (info) => Text(
                  "VERSION: ${info.buildNumber}",
                  style: textTheme.headlineSmall?.copyWith(color: ashGray),
                ),
                orElse: () => Container(),
              ),
        )
      ],
    );
  }
}
