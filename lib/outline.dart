import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'logic/panel_controller.dart';
import 'logic/size.dart';
import 'ui/dashboard.dart';
import 'ui/puzzle.dart';
import 'ui/theme/colors.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

BorderRadius get _borderRadius30 =>
    BorderRadius.vertical(top: Radius.circular(30.r));

class OutlinePage extends StatelessWidget {
  const OutlinePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: seaWhite,
        body: SafeArea(
          bottom: false,
          top: true,
          minimum: /*size == "mobile"
              ? EdgeInsets.symmetric(horizontal: 1.5.r)
              : */
              EdgeInsets.zero,
          child: SizedBox(
            width: 360.w,
            child: LayoutBuilder(
              builder: (_, constraint) {
                final double maxWidth = constraint.maxWidth;
                final double maxHeight = constraint.maxHeight;
                return size == "mobile"
                    ? SlidingUpPanel(
                        backdropEnabled: true,
                        backdropOpacity: 1,
                        color: seaWhite,
                        controller: panelController,
                        minHeight: 0,
                        maxHeight: maxHeight * 0.96,
                        padding: EdgeInsets.zero,
                        backdropColor: midnightGreen,
                        borderRadius: _borderRadius30,
                        panel: ClipRRect(
                          borderRadius: _borderRadius30,
                          child: const PuzzlePage(),
                        ),
                        body: OutlineState(maxWidth),
                      )
                    : OutlineState(maxWidth);
              },
            ),
          ),
        ),
      );
}

class OutlineState extends StatelessWidget {
  final double maxWidth;
  const OutlineState(this.maxWidth, {super.key});

  @override
  Widget build(BuildContext context) {
    double mobileWidth = 720.r;
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          constraints: BoxConstraints(maxWidth: mobileWidth),
          //color: aquaMarine,
          alignment: Alignment.topLeft,
          child: const PuzzlePage(),
        ),
        if (maxWidth > mobileWidth)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            right: 0,
            width: maxWidth - mobileWidth,
            child: AnimatedContainer(
              width: maxWidth - mobileWidth,
              duration: const Duration(milliseconds: 300),
              color: raisinBlack,
              height: 900.h,
            ),
          )
      ],
    );
  }
}
