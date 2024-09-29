import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../enum/enum.dart';
import 'color.dart';
import 'font.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [size])
PinTheme pinTheme(PinThemeRef ref,
    {required BoxConstraints constraints, Color color = raisinBlack}) {
  final double maxWidth = constraints.maxWidth;

  final double boxWidth = maxWidth * 0.0975;
  final DefaultTextTheme textTheme = DefaultTextTheme();
  final isConstraintMeasurement = ref.watch(sizeProvider) == ScreenSize.mobile;
  return PinTheme(
    constraints: BoxConstraints(
      minWidth: isConstraintMeasurement ? boxWidth : 40.r,
      maxHeight: 54.h,
    ),
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: color, width: 0.54.r)),
    ),
    textStyle: textTheme.headlineMedium?.copyWith(color: color),
  );
}

@Riverpod(keepAlive: true)
Gradient gradient(
  GradientRef ref, {
  List<Color> color = const <Color>[midnightGreen, gunMetal],
}) =>
    LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight, colors: color);
