import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class DefaultTextTheme extends TextTheme {
  @override
  TextStyle get titleMedium => GoogleFonts.carterOne(
        fontSize: 36.r,
        color: raisinBlack,
        wordSpacing: 0,
        letterSpacing: 0,
        height: 1.8,
      );

  @override
  TextStyle get titleSmall => GoogleFonts.carterOne(
        fontSize: 24.r,
        color: raisinBlack,
        wordSpacing: 0,
        letterSpacing: 0,
        height: 1.8,
      );

  @override
  TextStyle get bodyLarge => GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: raisinBlack,
        fontSize: 36.r,
        letterSpacing: 0,
        wordSpacing: 0,
        height: 1.8,
      );

  @override
  TextStyle get bodyMedium => GoogleFonts.rowdies(
        fontSize: 18.r,
        color: blackBean,
        letterSpacing: 0,
        height: 2.1,
        fontWeight: FontWeight.w300,
      );

  @override
  TextStyle get bodySmall => GoogleFonts.poppins(
        fontWeight: FontWeight.w300,
        color: raisinBlack,
        fontSize: 15.r,
        letterSpacing: 0,
        wordSpacing: 0,
        height: 0,
      );

  @override
  TextStyle get labelLarge => GoogleFonts.questrial(
        fontSize: 72.r,
        fontWeight: FontWeight.normal,
        color: midnightGreen,
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
      );

  @override
  TextStyle get labelMedium => GoogleFonts.questrial(
        fontSize: 30.r,
        fontWeight: FontWeight.normal,
        color: midnightGreen,
        letterSpacing: 0,
        height: 1.8,
        wordSpacing: 0,
      );

  @override
  TextStyle get labelSmall => GoogleFonts.questrial(
        fontSize: 13.5.r,
        fontWeight: FontWeight.normal,
        letterSpacing: 0,
        height: 0,
        color: midnightGreen,
      );

  @override
  TextStyle get displayLarge => GoogleFonts.paytoneOne(
        fontSize: 60.r,
        letterSpacing: 1.5,
        height: 0,
        color: seaWhite,
      );

  @override
  TextStyle get displayMedium => GoogleFonts.play(
        fontSize: 36.r,
        letterSpacing: 0,
        height: 0,
        color: seaWhite,
      );

  @override
  TextStyle get displaySmall => GoogleFonts.play(
        fontSize: 15.r,
        fontWeight: FontWeight.w300,
        letterSpacing: 0,
        height: 0,
        color: seaWhite,
      );

  @override
  TextStyle get headlineMedium => GoogleFonts.play(
        fontSize: 15.r,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 0,
        color: midnightGreen,
      );

  @override
  TextStyle get headlineSmall => GoogleFonts.questrial(
        fontSize: 15.r,
        fontWeight: FontWeight.w300,
        letterSpacing: 0,
        height: 1.5,
        color: midnightGreen,
      );
}
