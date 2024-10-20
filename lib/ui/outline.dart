import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:toastification/toastification.dart';

import '../enum/enum.dart';
import '../panel/pod.dart';
import '../panel/widget.dart';
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
    final ScreenSize size = ref.watch(sizeProvider);
    final bool mobile = size == ScreenSize.mobile;
    return ToastificationConfigProvider(
      config: ToastificationConfig(
        marginBuilder: (_, __) => EdgeInsets.symmetric(
          horizontal: 7.5.r,
          vertical: 15.r,
        ),
        alignment: Alignment.center,
        itemWidth: 450.r,
        animationDuration: const Duration(milliseconds: 600),
      ),
      child: Scaffold(
        backgroundColor: blackBean,
        body: SizedBox.expand(
          child: Builder(
            builder: (_) {
              if (!mobile) return OutlineState(child: child);
              final PanelWidget panelWidget = ref.watch(panelNotifierProvider);

              return SlidingUpPanel(
                backdropEnabled: panelWidget.backdropEnabled(),
                backdropOpacity: 1,
                isDraggable: false,
                color: seaWhite,
                controller: mobile ? ref.read(panelControllerProvider) : null,
                minHeight: 0,
                maxHeight: panelWidget.height(),
                padding: EdgeInsets.zero,
                backdropColor: gunMetal,
                slideDirection: panelWidget.direction(),
                borderRadius: _borderRadius(
                  15,
                  isTop: panelWidget.direction() == SlideDirection.UP,
                ),
                renderPanelSheet: true,
                panel: ClipRRect(
                  borderRadius: _borderRadius(
                    15,
                    isTop: panelWidget.direction() == SlideDirection.UP,
                  ),
                  child: panelWidget,
                ),
                body: OutlineState(child: child),
                onPanelClosed: () {
                  ref.read(panelNotifierProvider.notifier).state =
                      const EmptyPanel();
                },
              );
            },
          ),
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
    double mobileWidth = 900.r;
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
