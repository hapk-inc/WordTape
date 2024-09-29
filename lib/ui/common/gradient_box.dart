import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/color.dart';
import '../../theme/pod.dart';

class GradientBox extends ConsumerWidget {
  final Widget child;
  final List<Color> color;
  const GradientBox({
    required this.child,
    this.color = const <Color>[midnightGreen, gunMetal],
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => AnimatedContainer(
        duration: const Duration(milliseconds: 450),
        decoration: BoxDecoration(
          gradient: ref.read(gradientProvider(color: color)),
        ),
        alignment: Alignment.topCenter,
        padding: EdgeInsets.symmetric(horizontal: 7.5.r),
        child: child,
      );
}
