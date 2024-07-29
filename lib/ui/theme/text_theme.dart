import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

class DefaultTextTheme extends TextTheme {
  //
  @override
  TextStyle? get bodyLarge =>
      FontTheme.questrialTheme.copyWith(fontSize: 18.r, color: verdiGris);

  @override
  TextStyle? get bodyMedium =>
      FontTheme.questrialTheme.copyWith(fontSize: 15.r);

  @override
  TextStyle? get bodySmall => FontTheme.questrialTheme.copyWith(fontSize: 12.r);

  @override
  TextStyle? get headlineLarge =>
      FontTheme.montserratTheme.copyWith(fontSize: 21.r);

  @override
  TextStyle? get headlineMedium =>
      FontTheme.montserratTheme.copyWith(fontSize: 12.r);

  @override
  TextStyle? get headlineSmall =>
      FontTheme.montserratTheme.copyWith(fontSize: 9.r);

  @override
  TextStyle? get titleLarge =>
      FontTheme.questrialTheme.copyWith(fontSize: 60.r);

  static TextStyle get gugiTheme => FontTheme.gugiTheme;
}

mixin FontTheme {
  static TextStyle get gugiTheme => TextStyle(
        fontFamily: 'Gugi',
        fontSize: 15.r,
        color: prussianBlue,
      );

  static TextStyle get questrialTheme => TextStyle(
        fontFamily: 'Questrial',
        fontSize: 15.r,
        color: prussianBlue,
      );

  static TextStyle get poppinsTheme => TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w200,
        fontSize: 15.r,
      );

  static TextStyle get montserratTheme => TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 15.r,
        color: prussianBlue,
      );

  static TextStyle get nunitoTheme => TextStyle(
        fontFamily: 'Nunito',
        fontSize: 15.r,
        color: prussianBlue,
      );
}

/*ButtonStyle get buttonStyle => ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll(prussianBlue),
      foregroundColor: const WidgetStatePropertyAll(greenWhite),
      textStyle: WidgetStatePropertyAll(DefaultTextTheme().headlineMedium),
      minimumSize: WidgetStatePropertyAll(Size.square(48.r)),
      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 30.r)),
      elevation: WidgetStatePropertyAll(3.r),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      ),
    );*/
