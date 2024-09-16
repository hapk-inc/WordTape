import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color.dart';

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
        fontSize: 36.r,
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
        fontSize: 27.r,
        letterSpacing: 0,
        height: 2.4,
        wordSpacing: 0,
        color: raisinBlack,
      );

  @override
  TextStyle? get bodyMedium => GoogleFonts.questrial(
        fontSize: 21.r,
        letterSpacing: 0,
        height: 2.1,
        wordSpacing: 0,
        color: slateGray,
      );

  @override
  TextStyle? get bodySmall => GoogleFonts.questrial(
        fontSize: 18.r,
        color: raisinBlack,
        letterSpacing: 0,
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

  @override
  TextStyle? get displayMedium => GoogleFonts.paytoneOne(
        fontSize: 30.r,
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
        color: Colors.white54,
      );

  //==============

  @override
  TextStyle? get headlineLarge => GoogleFonts.play(
        fontSize: 24.r,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.8,
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

  @override
  TextStyle? get headlineSmall => GoogleFonts.play(
        fontSize: 14.r,
        fontWeight: FontWeight.w300,
        letterSpacing: 0,
        height: 0,
        color: midnightGreen,
      );

  // Exception - only for "PRESS START"
  @override
  TextStyle? get displaySmall => GoogleFonts.pressStart2p(
        color: mint,
        fontSize: 15.r,
        height: 0,
      );
}

mixin FontMixin {
  //TextStyle get kanit => GoogleFonts.kanit();
}
