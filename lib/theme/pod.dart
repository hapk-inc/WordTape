import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../enum/enum.dart';
import '../model/custom_theme.dart';
import 'color.dart';
import 'font.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [size])
PinTheme pinTheme(
  Ref ref, {
  required BoxConstraints constraints,
  Color color = raisinBlack,
}) {
  final double maxWidth = constraints.maxWidth;

  final double boxWidth = maxWidth * 0.0975;
  final DefaultTextTheme textTheme = DefaultTextTheme();
  final isConstraintMeasurement = ref.watch(sizeProvider) == ScreenSize.mobile;
  return PinTheme(
    constraints: BoxConstraints(
      minWidth: isConstraintMeasurement ? boxWidth : 40.r,
      maxHeight: 54.r,
    ),
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: color, width: 0.9.r),
      ),
    ),
    textStyle: textTheme.headlineMedium?.copyWith(color: color),
  );
}

@Riverpod(keepAlive: true)
Gradient gradient(
  Ref ref, {
  List<Color> color = const <Color>[/*midnightGreen, gunMetal*/],
}) =>
    LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight, colors: color);

@Riverpod(keepAlive: false)
CustomTheme customTheme(Ref ref, int index) {
  final List<CustomTheme> customThemes = <CustomTheme>[
    CustomTheme(
      forToday: [brown, sealBrown],
      pressColor: naplesYellow,
      btnColor: raisinBlack,
      prevTile: beige,
      completed: tigerEye,
      right: lightGreen,
      wrong: rustyRed,
    ),
    CustomTheme(
      forToday: [marianBlue, darkBlue],
      pressColor: uOrange,
      btnColor: raisinBlack,
      prevTile: magnolia,
      completed: marianBlue,
      right: turquoise,
      wrong: imperialRed,
    ),
    CustomTheme(
      forToday: [midnightGreen, gunMetal],
      pressColor: mint,
      btnColor: raisinBlack,
      prevTile: azureGreen,
      completed: midnightGreen,
    ),
    CustomTheme(
      forToday: [tyrianPurple, murray],
      pressColor: xantHous,
      btnColor: raisinBlack,
      prevTile: lavenderBlushPink,
      completed: cerise,
    ),
  ];
  return customThemes[index % 4];
}
