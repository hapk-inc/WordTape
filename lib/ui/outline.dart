import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../enum/enum.dart';
import '../panel/pod.dart';
import '../panel/widget.dart';
import '../router/router.dart';
import '../theme/color.dart';

BorderRadius _borderRadius(double radius, {bool isTop = true}) =>
    BorderRadius.vertical(
      top: isTop ? Radius.circular(radius.r) : Radius.zero,
      bottom: !isTop ? Radius.circular(radius.r) : Radius.zero,
    );

class OutlinePage extends ConsumerWidget {
  final Widget child;
  const OutlinePage(this.child, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: blackBean,
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Builder(
          builder: (_) {
            final ScreenSize size = ref.watch(sizeProvider);
            final bool isMobile = size == ScreenSize.mobile;
            if (!isMobile) return OutlineState(child: child);
            final PanelWidget? panelWidget = ref.watch(panelNotifierProvider);
            final SlideDirection direction =
                panelWidget?.direction() ?? SlideDirection.UP;
            return SlidingUpPanel(
              backdropEnabled: panelWidget?.backdropEnabled() ?? false,
              backdropOpacity: 1,
              isDraggable: false,
              color: seaWhite,
              controller: isMobile ? ref.read(panelControllerProvider) : null,
              minHeight: 0,
              maxHeight: panelWidget?.height() ?? 0.h,
              padding: EdgeInsets.zero,
              backdropColor: gunMetal,
              slideDirection: direction,
              borderRadius: _borderRadius(
                15,
                isTop: direction == SlideDirection.UP,
              ),
              renderPanelSheet: true,
              panel: ClipRRect(
                borderRadius: _borderRadius(
                  15,
                  isTop: direction == SlideDirection.UP,
                ),
                child: panelWidget,
              ),
              body: OutlineState(child: child),
              onPanelClosed: () {
                ref.read(panelNotifierProvider.notifier).state = null;
              },
            );
          },
        ),
      ),
    );
  }
}

class OutlineState extends ConsumerWidget {
  final Widget child;
  const OutlineState({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double mobileWidth = 750.r;
    final ScreenSize size = ref.watch(sizeProvider);
    return LayoutBuilder(
      builder: (_, constraints) => Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            alignment: Alignment.center,
            child: Card(
              margin: size == ScreenSize.pc
                  ? EdgeInsets.symmetric(vertical: 15.r)
                  : EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: size == ScreenSize.pc
                    ? BorderRadius.circular(15.r)
                    : BorderRadius.zero,
              ),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: ClipRRect(
                  borderRadius: size == ScreenSize.pc
                      ? BorderRadius.circular(15.r)
                      : BorderRadius.zero,
                  child: Container(
                    constraints: BoxConstraints.tightForFinite(
                      width: mobileWidth,
                    ),
                    child: child,
                  ),
                ),
              ),
            ),

            /*child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.all(7.5.r),
              constraints: BoxConstraints.tightForFinite(width: mobileWidth),
              color: seaWhite,
              alignment: Alignment.topLeft,
              child: child,
            ),*/
          ),
          /*if (maxWidth > mobileWidth)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 150),
                right: 0,
                width: maxWidth - mobileWidth,
                child: Container(color: blackBean, height: 900.h),
              )*/
        ],
      ),
    );
  }
}
