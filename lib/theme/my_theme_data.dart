import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';
import 'text_theme.dart';

MyTextTheme _textTheme = MyTextTheme();

ThemeData buildThemeData() => ThemeData(
      //tooltipTheme: TooltipThemeData(),
      colorScheme: ColorScheme.fromSeed(seedColor: teal, surface: prussianBlue),
      useMaterial3: true,
      scaffoldBackgroundColor: greenWhite,
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        toolbarHeight: 90.h,
        titleSpacing: 7.5.r,
        backgroundColor: greenWhite,
        centerTitle: false,
        titleTextStyle: _textTheme.titleSmall?.copyWith(color: filledColor),
        elevation: 0,
        iconTheme: IconThemeData(color: slateGray, size: 21.r),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: _buttonStyle),
      primaryTextTheme: _textTheme,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: raisinBlack,
        contentTextStyle: _textTheme.bodyLarge?.copyWith(
          color: greenWhite,
          height: 1.8,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: _buttonStyle.copyWith(
          foregroundColor: const WidgetStatePropertyAll(payneGray),
          textStyle: WidgetStatePropertyAll(_textTheme.headlineMedium),
        ),
      ),
      //iconButtonTheme: IconButtonThemeData(style: _buttonStyle),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _buttonStyle.copyWith(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
          ),
          foregroundColor: const WidgetStatePropertyAll(payneGray),
          textStyle: WidgetStatePropertyAll(
            _textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(width: 0.45.r, color: payneGray),
          ),
        ),
      ),
    );

ButtonStyle get _buttonStyle => ButtonStyle(
      textStyle: WidgetStatePropertyAll(_textTheme.headlineSmall),
      minimumSize: WidgetStatePropertyAll(Size.square(kIsWeb ? 48.h : 45.h)),
      padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 30.r, vertical: 15.r) * 0.96),
    );
