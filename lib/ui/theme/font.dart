import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class DefaultTextTheme extends TextTheme with FontMixin {
  @override
  TextStyle get bodyLarge => GoogleFonts.rowdies(
        fontSize: 24.r,
        color: raisinBlack,
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
        fontWeight: FontWeight.w200,
      );

  @override
  TextStyle get bodyMedium => GoogleFonts.rowdies(
        fontSize: 21.r,
        fontWeight: FontWeight.w300,
        color: raisinBlack,
        letterSpacing: 0,
        height: 2.1,
      );

  @override
  TextStyle? get titleMedium => GoogleFonts.carterOne(
        fontSize: 30.r,
        letterSpacing: 0,
      );

  @override
  TextStyle? get titleLarge => GoogleFonts.carterOne(
        fontSize: 36.r,
        letterSpacing: 0,
        height: 2.1,
      );

  @override
  TextStyle? get labelLarge => GoogleFonts.paytoneOne(
        fontSize: 72.r,
        letterSpacing: 0,
        height: 0,
        color: seaWhite,
      );

  @override
  TextStyle? get labelMedium => GoogleFonts.questrial(
        fontSize: 24.r,
        letterSpacing: 0,
      );
}

mixin FontMixin {
  //TextStyle get kanit => GoogleFonts.kanit();
}
