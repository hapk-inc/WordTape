import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_theme.freezed.dart';

@freezed
class CustomTheme with _$CustomTheme {
  const factory CustomTheme({
    required List<Color> forToday,
    required Color pressColor,
    required Color btnColor,
    required Color prevTile,
    required Color completed,
    @Default(Color(0xff56E38F)) Color right,
    @Default(Color(0xffFFA69E)) Color wrong,
  }) = _CustomTheme;
}
