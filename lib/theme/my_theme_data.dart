import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';
import 'text_theme.dart';

MyTextTheme _textTheme = MyTextTheme();

ThemeData buildThemeData() => ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: teal, surface: prussianBlue),
      useMaterial3: true,
      scaffoldBackgroundColor: greenWhite,
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        toolbarHeight: 75.h,
        backgroundColor: greenWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: slateGray, size: 24.r),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: _buttonStyle),
      primaryTextTheme: _textTheme,
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(_textTheme.headlineSmall),
        ),
      ),
      //iconButtonTheme: IconButtonThemeData(style: _buttonStyle),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _buttonStyle.copyWith(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
          textStyle: WidgetStatePropertyAll(
              _textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
          side: const WidgetStatePropertyAll(
            BorderSide(width: 0.45, color: slateGray),
          ),
        ),
      ),
    );

ButtonStyle get _buttonStyle => ButtonStyle(
      textStyle: WidgetStatePropertyAll(_textTheme.headlineSmall),
      minimumSize: const WidgetStatePropertyAll(Size.square(40)),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 27.r, vertical: 15.r),
      ),
    );
