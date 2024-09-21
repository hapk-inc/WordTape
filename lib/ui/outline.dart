import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../enum/pod.dart';
import '../function/auth/pod.dart';
import '../function/controller/pod.dart';
import 'theme/color.dart';

BorderRadius get _borderRadius30 =>
    BorderRadius.vertical(top: Radius.circular(30.r));

const Duration _m3600 = Duration(milliseconds: 3600);

class OutlinePage extends ConsumerStatefulWidget {
  final Widget child;
  const OutlinePage(this.child, {super.key});

  @override
  ConsumerState<OutlinePage> createState() => _OutlinePageState();
}

class _OutlinePageState extends ConsumerState<OutlinePage> {
  @override
  void initState() {
    Future.delayed(_m3600, () => ref.read(listenAuthProvider));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenSize size = ref.watch(sizeProvider);
    final bool isMobile = size == ScreenSize.mobile;

    return Scaffold(
      backgroundColor: blackBean,
      body: LayoutBuilder(
        builder: (_, constraints) => SizedBox.expand(
          child: isMobile
              ? SlidingUpPanel(
                  backdropEnabled: true,
                  backdropOpacity: 1,
                  isDraggable: false,
                  color: seaWhite,
                  controller: ref.watch(panelControllerProvider),
                  minHeight: 0,
                  maxHeight: constraints.maxHeight * 0.9,
                  padding: EdgeInsets.zero,
                  backdropColor: midnightGreen,
                  borderRadius: _borderRadius30,
                  renderPanelSheet: false,
                  panel: ClipRRect(
                    borderRadius: _borderRadius30,
                    child: ref.watch(puzzlePanelProvider),
                  ),
                  body: OutlineState(child: widget.child),
                )
              : OutlineState(child: widget.child),
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
    double mobileWidth = 750.r;
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        return Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              constraints: BoxConstraints(maxWidth: mobileWidth),
              color: seaWhite,
              alignment: Alignment.topLeft,
              child: child,
            ),
            if (maxWidth > mobileWidth)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 150),
                right: 0,
                width: maxWidth - mobileWidth,
                child: Container(color: blackBean, height: 900.h),
              )
          ],
        );
      },
    );
  }
}
