import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

// title
// questrial - body for Normal; carterOne for Highlighter (title)

// payOne - Logo

// puzzle
// play for wordText;(in headline)

//  and button text - bodySmall

//

class DefaultTextTheme extends TextTheme with FontMixin {
  //Title==============
  @override
  TextStyle? get titleLarge => GoogleFonts.carterOne(
        fontSize: 40.r,
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
        color: raisinBlack,
      );

  @override
  TextStyle? get titleMedium => GoogleFonts.carterOne(
        fontSize: 24.r,
        letterSpacing: 0,
        height: 1.8,
        wordSpacing: 0,
        color: raisinBlack,
      );

  //Body==============
  @override
  TextStyle? get bodyLarge => GoogleFonts.questrial(
        fontSize: 30.r,
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
        color: raisinBlack,
      );

  @override
  TextStyle? get bodyMedium => GoogleFonts.questrial(
        fontSize: 21.r,
        letterSpacing: 0.03,
        height: 2.1,
        wordSpacing: 0,
        color: slateGray,
      );

  @override
  TextStyle? get bodySmall => GoogleFonts.questrial(
        fontSize: 18.r,
        color: raisinBlack,
        letterSpacing: 0.03,
        height: 0,
        wordSpacing: 0,
      );

//=============
  @override
  TextStyle? get displayLarge => GoogleFonts.paytoneOne(
        fontSize: 72.r,
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
        color: seaWhite,
      );

  //==============

  @override
  TextStyle? get headlineLarge => GoogleFonts.play(
        fontSize: 24.r,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 0,
        color: midnightGreen,
      );

  @override
  TextStyle? get headlineMedium => GoogleFonts.play(
        fontSize: 16.r,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 0,
        color: midnightGreen,
      );
}

mixin FontMixin {
  //TextStyle get kanit => GoogleFonts.kanit();
}
