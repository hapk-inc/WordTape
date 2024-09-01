import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class DefaultTextTheme extends TextTheme with FontMixin {
  //Title==============
  @override
  TextStyle? get titleLarge => GoogleFonts.carterOne(
        fontSize: 45.r,
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
        color: raisinBlack,
      );

  @override
  TextStyle? get titleMedium => GoogleFonts.carterOne(
        fontSize: 30.r,
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
        color: raisinBlack,
      );

  //Body==============
  @override
  TextStyle? get bodyLarge => GoogleFonts.questrial(
        fontSize: 36.r,
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
        color: raisinBlack,
      );

  @override
  TextStyle? get bodyMedium => GoogleFonts.questrial(
        fontSize: 24.r,
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
        color: raisinBlack,
      );

  @override
  TextStyle? get bodySmall => GoogleFonts.questrial(
        fontSize: 15.r,
        color: raisinBlack,
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
      );

  //Headline==============
  @override
  TextStyle? get headlineMedium => GoogleFonts.cabin(
        fontSize: 24.r,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
        color: raisinBlack,
      );

  @override
  TextStyle? get headlineSmall => GoogleFonts.cabin(
        fontSize: 18.r,
        fontWeight: FontWeight.w900,
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
      );

  @override
  TextStyle? get displayLarge => GoogleFonts.paytoneOne(
        fontSize: 72.r,
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
        color: seaWhite,
      );

  @override
  TextStyle? get labelLarge => GoogleFonts.rowdies(
        fontSize: 45.r,
        color: raisinBlack,
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
      );

  @override
  TextStyle? get labelMedium => GoogleFonts.rowdies(
        fontSize: 18.r,
        color: raisinBlack,
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
      );
}

mixin FontMixin {
  //TextStyle get kanit => GoogleFonts.kanit();
}
