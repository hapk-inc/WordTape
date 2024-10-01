import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../enum/enum.dart';
import '../panel/pod.dart';
import '../theme/color.dart';

BorderRadius _borderRadius(double radius) =>
    BorderRadius.vertical(top: Radius.circular(radius.r));

class OutlinePage extends ConsumerWidget {
  final Widget child;
  const OutlinePage(this.child, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScreenSize size = ref.watch(sizeProvider);
    final bool mobile = size == ScreenSize.mobile;
    return Scaffold(
      backgroundColor: blackBean,
      body: SizedBox.expand(
        child: LayoutBuilder(
          builder: (context, constraints) => mobile
              ? SlidingUpPanel(
                  backdropEnabled: true,
                  backdropOpacity: 1,
                  isDraggable: false,
                  color: seaWhite,
                  controller: mobile ? ref.read(panelControllerProvider) : null,
                  minHeight: 0,
                  maxHeight: ref.watch(panelNotifierProvider).height(),
                  padding: EdgeInsets.zero,
                  backdropColor: gunMetal,
                  slideDirection: ref.watch(panelNotifierProvider).direction(),
                  borderRadius: _borderRadius(30),
                  renderPanelSheet: false,
                  panel: ClipRRect(
                    borderRadius: _borderRadius(30),
                    child: ref.watch(panelNotifierProvider),
                  ),
                  body: OutlineState(child: child),
                  onPanelClosed: () {},
                )
              : OutlineState(child: child),
        ),
      ),
    );
  }
}

class OutlineState extends StatelessWidget {
  final Widget child;
  const OutlineState({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    double mobileWidth = 720.r;
    return LayoutBuilder(
      builder: (_, constraints) {
        // final double maxWidth = constraints.maxWidth;
        return Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                constraints: BoxConstraints(maxWidth: mobileWidth),
                color: seaWhite,
                alignment: Alignment.topLeft,
                child: child,
              ),
            ),
            /*if (maxWidth > mobileWidth)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 150),
                right: 0,
                width: maxWidth - mobileWidth,
                child: Container(color: blackBean, height: 900.h),
              )*/
          ],
        );
      },
    );
  }
}
