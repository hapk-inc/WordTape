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
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.5.r),
        ),
      ),
      appBarTheme: AppBarTheme(
        toolbarHeight: 90.h,
        titleSpacing: 7.5.r,
        backgroundColor: greenWhite,
        centerTitle: false,
        titleTextStyle: _textTheme.titleSmall?.copyWith(color: teal),
        elevation: 0,
        iconTheme: const IconThemeData(color: slateGray, size: 18),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: _buttonStyle),
      primaryTextTheme: _textTheme,
      //actionIconTheme: ActionIconThemeData(),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: raisinBlack,
        contentTextStyle: _textTheme.headlineMedium?.copyWith(
          color: greenWhite,
          height: 1.8,
        ),
        insetPadding: EdgeInsets.zero,
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
      minimumSize: WidgetStatePropertyAll(
        Size.square(kIsWeb ? 48.h : 40.5.h),
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: 30.r,
          vertical: kIsWeb ? 15.r : 0,
        ),
      ),
      elevation: WidgetStatePropertyAll(3.r),
    );
