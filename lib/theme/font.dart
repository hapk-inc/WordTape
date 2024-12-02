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
  TextStyle? get titleLarge => carterFont.copyWith(fontSize: 24.r);

  @override
  TextStyle? get titleMedium => carterFont.copyWith(
        fontSize: 24.r,
        height: 1.8,
      );

  //Body==============
  @override
  TextStyle? get bodyLarge => questrialFont.copyWith(
        fontSize: 22.5.r,
        height: 2,
      );

  @override
  TextStyle? get bodyMedium => questrialFont.copyWith(
        fontSize: 21.r,
        height: 1.8,
      );

  @override
  TextStyle? get bodySmall => questrialFont.copyWith(
        fontSize: 16.r,
        height: 1.8,
      );

//=============
  @override
  TextStyle? get displayLarge => paytoneFont.copyWith(fontSize: 54.r);

  @override
  TextStyle? get displayMedium => paytoneFont.copyWith(fontSize: 36.r);

  @override
  TextStyle? get displaySmall => paytoneFont.copyWith(fontSize: 30.r);

  //==============

  @override
  TextStyle? get headlineLarge => playFont.copyWith(
        fontSize: 24.r,
        height: 1.8,
      );

  @override
  TextStyle? get headlineMedium => playFont.copyWith(fontSize: 16.r);

  @override
  TextStyle? get headlineSmall => playFont.copyWith(
        fontSize: 15.r,
        height: 2.1,
        color: cadetGray,
        fontWeight: FontWeight.normal,
      );

  // Exception - only for "PRESS START"
  @override
  TextStyle? get labelSmall => press2pFont.copyWith(
        color: mint,
        fontSize: 15.r,
      );

  TextStyle get urlTheme => robotoMonoFont.copyWith(fontSize: 15.r);

  TextStyle get emojiMedium => notoEmojiFont.copyWith(fontSize: 36.r);

  TextStyle get emojiSmall => notoEmojiFont.copyWith(fontSize: 24.r);

  TextStyle get kanitLarge => kanitFont.copyWith(fontSize: 21.r);

  TextStyle get kanitMedium => kanitFont.copyWith(
        fontSize: 18.r,
        fontWeight: FontWeight.w300,
      );
}

mixin FontMixin {
  TextStyle get carterFont => const TextStyle(
        fontFamily: 'CarterOne',
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
        color: raisinBlack,
      );

  TextStyle get paytoneFont => const TextStyle(
        fontFamily: 'PaytoneOne',
        letterSpacing: 0,
        height: 0,
        wordSpacing: 0,
        color: seaWhite,
      );

  TextStyle get playFont => const TextStyle(
        fontFamily: 'Play',
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 0,
        color: midnightGreen,
      );

  TextStyle get press2pFont => const TextStyle(
        fontFamily: 'PressStart2P',
        height: 0,
        letterSpacing: 0,
        wordSpacing: 0,
      );

  TextStyle get questrialFont => const TextStyle(
        fontFamily: 'Questrial',
        letterSpacing: 0,
        wordSpacing: 0,
        color: slateGray,
      );

  TextStyle get robotoMonoFont => const TextStyle(
        fontFamily: 'RobotoMono',
        letterSpacing: 0,
        wordSpacing: 0,
        color: slateGray,
      );

  TextStyle get notoEmojiFont => TextStyle(
        fontFamily: 'NotoColorEmoji',
        letterSpacing: 0.3.r,
        height: 0.r,
        wordSpacing: 0,
      );

  TextStyle get kanitFont => const TextStyle(
        fontFamily: 'Kanit',
        height: 0,
        letterSpacing: 0,
        wordSpacing: 0,
      );
}
