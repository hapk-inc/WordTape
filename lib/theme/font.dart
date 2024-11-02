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
  TextStyle? get titleLarge => carterTheme.copyWith(fontSize: 24.r);

  @override
  TextStyle? get titleMedium => carterTheme.copyWith(
        fontSize: 24.r,
        height: 1.8,
      );

  //Body==============
  @override
  TextStyle? get bodyLarge => questrialTheme.copyWith(
        fontSize: 22.5.r,
        height: 2.1,
      );

  @override
  TextStyle? get bodyMedium => questrialTheme.copyWith(
        fontSize: 21.r,
        height: 1.8,
      );

  @override
  TextStyle? get bodySmall => questrialTheme.copyWith(
        fontSize: 16.r,
        height: 1.8,
      );

//=============
  @override
  TextStyle? get displayLarge => paytoneTheme.copyWith(fontSize: 54.r);

  @override
  TextStyle? get displayMedium => paytoneTheme.copyWith(fontSize: 36.r);

  @override
  TextStyle? get displaySmall => paytoneTheme.copyWith(
        fontSize: 30.r,
      );

  //==============

  @override
  TextStyle? get headlineLarge => playTheme.copyWith(
        fontSize: 24.r,
        height: 1.8,
      );

  @override
  TextStyle? get headlineMedium => playTheme.copyWith(fontSize: 16.r);

  @override
  TextStyle? get headlineSmall => playTheme.copyWith(fontSize: 14.r);

  // Exception - only for "PRESS START"
  @override
  TextStyle? get labelSmall => press2pTheme.copyWith(
        color: mint,
        fontSize: 15.r,
        height: 0,
      );

  TextStyle get urlTheme => robotoMonoTheme.copyWith(
        fontSize: 15.r,
        color: slateGray,
        height: 0,
        letterSpacing: 0,
        wordSpacing: 0,
      );

  TextStyle get emojiTheme => notoColorEmojiTheme.copyWith(
        fontSize: 36.r,
        letterSpacing: 0.3.r,
        height: 0.r,
      );

  TextStyle get emojiSmall => notoColorEmojiTheme.copyWith(
        fontSize: 24.r,
        letterSpacing: 0.3.r,
        color: seaWhite,
        height: 0.r,
      );

  TextStyle get montserratLarge => montserratTheme.copyWith(
        fontSize: 21.r,
        fontWeight: FontWeight.w600,
      );

  TextStyle get montserratMedium => montserratTheme.copyWith(fontSize: 15.r);
}

mixin FontMixin {
  TextStyle get carterTheme => const TextStyle(
        fontFamily: 'CarterOne',
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
        color: raisinBlack,
      );

  TextStyle get paytoneTheme => const TextStyle(
        fontFamily: 'PaytoneOne',
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
        color: seaWhite,
      );

  TextStyle get playTheme => const TextStyle(
        fontFamily: 'Play',
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 0,
        color: midnightGreen,
      );

  TextStyle get press2pTheme => const TextStyle(fontFamily: 'PressStart2P');

  TextStyle get questrialTheme => const TextStyle(
        fontFamily: 'Questrial',
        letterSpacing: 0,
        wordSpacing: 0,
        color: slateGray,
      );

  TextStyle get montserratTheme => const TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        wordSpacing: 0,
        color: slateGray,
      );

  TextStyle get robotoMonoTheme => const TextStyle(
        fontFamily: 'RobotoMono',
        letterSpacing: 0,
        wordSpacing: 0,
        color: slateGray,
      );

  TextStyle get notoColorEmojiTheme => const TextStyle(
        fontFamily: 'NotoColorEmoji',
        letterSpacing: 0,
        wordSpacing: 0,
      );

  TextStyle get latoTheme => const TextStyle(
        fontFamily: 'Lato',
        fontWeight: FontWeight.bold,
        letterSpacing: 0,
        color: raisinBlack,
        wordSpacing: 0,
        height: 1.8,
      );

  TextStyle get poppinsTheme => const TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: raisinBlack,
        wordSpacing: 0,
        height: 1.5,
      );
}
