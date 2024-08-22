import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'logic/panel_controller.dart';
import 'logic/puzzle/puzzle_panel.dart';
import 'logic/size.dart';
import 'ui/theme/colors.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

BorderRadius get _borderRadius30 =>
    BorderRadius.vertical(top: Radius.circular(30.r));

@RoutePage()
class OutlinePage extends ConsumerWidget {
  const OutlinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String size = ref.watch(sizeProvider);
    return Scaffold(
      backgroundColor: seaWhite,
      body: SizedBox.expand(
        child: size == "mobile"
            ? SlidingUpPanel(
                backdropEnabled: true,
                backdropOpacity: 1,
                isDraggable: false,
                color: seaWhite,
                controller: ref.watch(panelControllerProvider),
                minHeight: 0,
                maxHeight: 810.h,
                padding: EdgeInsets.zero,
                backdropColor: midnightGreen,
                borderRadius: _borderRadius30,
                renderPanelSheet: false,
                panel: ClipRRect(
                  borderRadius: _borderRadius30,
                  child: ref.watch(puzzlePanelProvider),
                ),
                body: const OutlineState(),
              )
            : const OutlineState(),
      ),
    );
  }
}

class OutlineState extends ConsumerStatefulWidget {
  const OutlineState({super.key});

  @override
  ConsumerState<OutlineState> createState() => _OutlineStateState();
}

class _OutlineStateState extends ConsumerState<OutlineState> {
  @override
  Widget build(BuildContext context) {
    double mobileWidth = 720.r;
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        return Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              constraints: BoxConstraints(maxWidth: mobileWidth),
              color: seaWhite,
              //color: aquaMarine,
              alignment: Alignment.topLeft,
              //child: const DashboardPage(),
              child: const AutoRouter(),
            ),
            if (maxWidth > mobileWidth)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 150),
                right: 0,
                width: maxWidth - mobileWidth,
                child: AnimatedContainer(
                  width: maxWidth - mobileWidth,
                  duration: const Duration(milliseconds: 300),
                  color: blackBean,
                  height: 900.h,
                ),
              )
          ],
        );
      },
    );
  }
}
