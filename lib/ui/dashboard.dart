import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:animate_do/animate_do.dart';

import '../logic/app/panel.dart';
import '../theme/colors.dart';
import 'dashboard/button_bar.dart';
import 'dashboard/puzzle_calendar.dart';
import 'dashboard/selected_found.dart';

@RoutePage()
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final TextTheme tTheme = Theme.of(context).textTheme;

    return Container(
      color: greenWhite,
      child: Stack(
        children: [
          Column(
            children: [
              const PuzzleCalendar(),
              Container(height: 210.r),
              FadeIn(
                child: Text(
                  "WORDTAPE",
                  style: tTheme.titleLarge?.copyWith(color: engineeringOrange),
                ),
              ),
              Gap(15.r),
              Text(
                "Creating a word combination sequence",
                style: tTheme.bodyMedium?.copyWith(color: payneGray),
              ),
              Gap(30.h),
              const DButtonBar(),
              Gap(30.h),
              const SelectedFound(),
            ],
          ),
          SlidingUpPanel(
            backdropColor: raisinBlack,
            padding: EdgeInsets.symmetric(horizontal: 4.5.r),
            backdropEnabled: true,
            backdropOpacity: 0.75,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
            minHeight: 0,
            maxHeight: ref.watch(panelNotifierProvider).height,
            controller: ref.read(dashboardPanelProvider),
            panel: ref.watch(panelNotifierProvider).child,
          ),
        ],
      ),
    );
  }
}
