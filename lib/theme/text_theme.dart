import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

class MyTextTheme extends TextTheme {
  @override
  TextStyle? get bodyLarge => FontTheme.questrialTheme.copyWith(fontSize: 18.r);

  @override
  TextStyle? get bodyMedium =>
      FontTheme.questrialTheme.copyWith(fontSize: 16.r);

  @override
  TextStyle? get bodySmall => FontTheme.questrialTheme.copyWith(fontSize: 12);

  @override
  TextStyle? get titleLarge => FontTheme.gugiTheme.copyWith(fontSize: 60.r);

  @override
  TextStyle? get titleMedium => FontTheme.gugiTheme.copyWith(fontSize: 27.r);

  @override
  TextStyle? get titleSmall => FontTheme.gugiTheme.copyWith(fontSize: 21.r);

  @override
  TextStyle? get headlineLarge =>
      FontTheme.montserratTheme.copyWith(fontSize: 24.r);

  @override
  TextStyle? get headlineMedium =>
      FontTheme.montserratTheme.copyWith(fontSize: 15.r);

  @override
  TextStyle? get headlineSmall => FontTheme.montserratTheme.copyWith(
        fontSize: 13.5.r,
        fontWeight: FontWeight.w700,
      );

  //NUNITO THEME
  @override
  TextStyle? get labelMedium => FontTheme.nunitoTheme.copyWith(
        fontSize: 18.r,
        fontWeight: FontWeight.w300,
      );

  @override
  TextStyle? get labelSmall => FontTheme.montserratTheme.copyWith(
        fontSize: 15.r,
        fontWeight: FontWeight.w300,
      );
}

mixin FontTheme {
  static TextStyle get gugiTheme => const TextStyle(
        fontFamily: 'Gugi',
        letterSpacing: 0,
        height: 0,
        fontSize: 14,
        color: greenWhite,
      );

  static TextStyle get questrialTheme => const TextStyle(
        fontFamily: 'Questrial',
        letterSpacing: 0,
        height: 0,
        fontSize: 14,
        color: payneGray,
      );

  static TextStyle get poppinsTheme => const TextStyle(
        fontFamily: 'Poppins',
        letterSpacing: 0,
        fontWeight: FontWeight.w200,
        fontSize: 14,
        height: 0,
      );

  static TextStyle get montserratTheme => const TextStyle(
        fontFamily: 'Montserrat',
        letterSpacing: 0,
        fontWeight: FontWeight.w700,
        height: 0,
        fontSize: 14,
        color: payneGray,
      );

  static TextStyle get nunitoTheme => const TextStyle(
        fontFamily: 'Nunito',
        letterSpacing: 0,
        height: 0,
        fontSize: 14,
        color: payneGray,
      );
}
