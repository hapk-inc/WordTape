import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../logic/app/panel.dart';
import '../model/panel_widget.dart';
import '../theme/colors.dart';
import 'dashboard/button_bar.dart';
import 'dashboard/puzzle_calendar.dart';

@RoutePage()
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme tTheme = Theme.of(context).textTheme;
    final PanelWidget panelWidget = ref.watch(panelNotifierProvider);

    return Container(
      color: greenWhite,
      child: Stack(
        children: [
          SingleChildScrollView(
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
                      style: tTheme.titleLarge?.copyWith(
                        color: engineeringOrange,
                        height: 1.5,
                      ),
                    ),
                    subtitle: const Text(
                      "  Challenging word puzzle game",
                      style: TextStyle(color: slateGray, height: 1.5),
                    ),
                  ),
                ),
                Gap(30.r),
                const DashboardButtonBar()
              ],
            ),
          ),
          SlidingUpPanel(
            backdropColor: raisinBlack,
            padding: EdgeInsets.symmetric(horizontal: 4.5.r),
            backdropEnabled: true,
            backdropOpacity: 0.75,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
            minHeight: 0,
            maxHeight: panelWidget.height,
            controller: ref.read(dashboardPanelProvider),
            panel: panelWidget.child,
          ),
        ],
      ),
    );
  }
}
