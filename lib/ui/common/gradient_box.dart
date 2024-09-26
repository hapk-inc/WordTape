import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/color.dart';

class GradientBox extends StatelessWidget {
  final Widget child;
  const GradientBox({required this.child, super.key});

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 450),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[midnightGreen, gunMetal],
          ),
        ),
        alignment: Alignment.topCenter,
        padding: EdgeInsets.symmetric(horizontal: 7.5.r),
        child: child,
      );
}
