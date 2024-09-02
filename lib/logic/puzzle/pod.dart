import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../enum/pod.dart';
import '../../ui/theme/colors.dart';
import '../../ui/theme/font.dart';
part 'pod.g.dart';

@riverpod
DateTime jun10(Jun10Ref ref) => DateTime(2024, 6, 9);

@Riverpod(keepAlive: true, dependencies: [])
class SelectedDate extends _$SelectedDate {
  @override
  DateTime build() => DateTime.now();

  @override
  set state(DateTime value) {
    if (super.state == value) return;

    super.state = value;
  }
}

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
      //color: cerise,
      border: Border(
        bottom: BorderSide(color: color, width: 0.54.r),
      ),
    ),
    textStyle: textTheme.headlineMedium?.copyWith(color: color),
  );
}
