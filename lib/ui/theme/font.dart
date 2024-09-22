import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  TextStyle? get titleLarge => carterTheme.copyWith(
        fontSize: 36.r,
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
        color: raisinBlack,
      );

  @override
  TextStyle? get titleMedium => carterTheme.copyWith(
        fontSize: 24.r,
        letterSpacing: 0,
        height: 1.8,
        wordSpacing: 0,
        color: raisinBlack,
      );

  //Body==============
  @override
  TextStyle? get bodyLarge => questrialTheme.copyWith(
        fontSize: 27.r,
        letterSpacing: 0,
        height: 2.1,
        wordSpacing: 0,
        color: raisinBlack,
      );

  @override
  TextStyle? get bodyMedium => questrialTheme.copyWith(
        fontSize: 21.r,
        letterSpacing: 0,
        height: 1.8,
        wordSpacing: 0,
        color: slateGray,
      );

  @override
  TextStyle? get bodySmall => questrialTheme.copyWith(
        fontSize: 18.r,
        color: Colors.black45,
        letterSpacing: 0,
        height: 1.8,
        wordSpacing: 0,
      );

//=============
  @override
  TextStyle? get displayLarge => paytoneTheme.copyWith(
        fontSize: 72.r,
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
        color: seaWhite,
      );

  @override
  TextStyle? get displayMedium => paytoneTheme.copyWith(
        fontSize: 45.r,
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
        color: Colors.white54,
      );

  @override
  TextStyle? get displaySmall => paytoneTheme.copyWith(
        fontSize: 36.r,
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
        color: Colors.white54,
      );

  //==============

  @override
  TextStyle? get headlineLarge => playTheme.copyWith(
        fontSize: 24.r,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.8,
        color: midnightGreen,
      );

  @override
  TextStyle? get headlineMedium => playTheme.copyWith(
        fontSize: 16.r,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 0,
        color: midnightGreen,
      );

  @override
  TextStyle? get headlineSmall => playTheme.copyWith(
        fontSize: 14.r,
        letterSpacing: 0,
        height: 0,
        color: midnightGreen,
      );

  // Exception - only for "PRESS START"
  @override
  TextStyle? get labelSmall => press2pTheme.copyWith(
        color: mint,
        fontSize: 15.r,
        height: 0,
      );
}

mixin FontMixin {
  TextStyle get carterTheme => const TextStyle(fontFamily: 'CarterOne');
  TextStyle get paytoneTheme => const TextStyle(fontFamily: 'PaytoneOne');
  TextStyle get playTheme => const TextStyle(fontFamily: 'Play');
  TextStyle get press2pTheme => const TextStyle(fontFamily: 'PressStart2P');
  TextStyle get questrialTheme => const TextStyle(fontFamily: 'Questrial');
}
