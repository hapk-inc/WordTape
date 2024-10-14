import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wordtape/function/connectivity/pod.dart';

import 'enum/enum.dart';
import 'router/router.dart';
import 'theme/color.dart';
import 'theme/font.dart';

class App extends ConsumerWidget with CustomThemeMixin {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.read(routerProvider);
    return ScreenUtilInit(
      designSize: const Size(360, 900),
      builder: (context, child) {
        final double mW = 360.w;
        final ScreenSize size = _validateSize(mW);
        ref.read(listenConnectivityProvider);
        return ProviderScope(
          overrides: [sizeProvider.overrideWithValue(size)],
          child: MaterialApp.router(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeData(
              iconTheme: iconThemeData,
              textTheme: defaultTextTheme,
              appBarTheme: AppBarTheme(
                toolbarHeight: 90.h,
                backgroundColor: midnightGreen,
                iconTheme: IconThemeData(color: seaWhite, size: 18.r),
                centerTitle: false,
                titleSpacing: 0,
              ),
              snackBarTheme: SnackBarThemeData(
                insetPadding: EdgeInsets.zero,
                contentTextStyle: defaultTextTheme.bodySmall?.copyWith(
                  color: seaWhite,
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                enabledBorder: underlineInputBorder(slateGray),
                focusedBorder: underlineInputBorder(seaWhite),
                errorBorder: underlineInputBorder(cerise),
                focusedErrorBorder: underlineInputBorder(cerise),
                contentPadding: const EdgeInsets.only(bottom: 9.6),
                filled: false,
                hintStyle: defaultTextTheme.bodyLarge,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: defaultButtonStyle.copyWith(
                  backgroundColor: const WidgetStatePropertyAll(blackBean),
                ),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: defaultButtonStyle.copyWith(
                  side: WidgetStatePropertyAll(outlineBorder),
                  foregroundColor: const WidgetStatePropertyAll(slateGray),
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: defaultButtonStyle.copyWith(
                  foregroundColor: const WidgetStatePropertyAll(slateGray),
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 15.r),
                  ),
                  minimumSize: WidgetStatePropertyAll(Size(90.r, 45.r)),
                  textStyle: WidgetStatePropertyAll(defaultTextTheme.urlTheme),
                ),
              ),
            ),
            routerConfig: router,
          ),
        );
      },
    );
  }
}

ScreenSize _validateSize(double mW) {
  if (mW < 420.r) return ScreenSize.mobile;
  return mW < 750.r ? ScreenSize.tab : ScreenSize.pc;
}

mixin CustomThemeMixin {
  IconThemeData get iconThemeData => IconThemeData(
        size: 18.r,
        color: slateGray,
      );

  DefaultTextTheme get defaultTextTheme => DefaultTextTheme();

  ButtonStyle get defaultButtonStyle => ButtonStyle(
        elevation: WidgetStatePropertyAll(1.5.r),
        textStyle: WidgetStatePropertyAll(
          defaultTextTheme.bodySmall?.copyWith(
            height: 0,
            fontSize: 16.r,
          ),
        ),
        minimumSize: WidgetStatePropertyAll(Size(150.r, 54.r)),
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 30.r)),
        foregroundColor: const WidgetStatePropertyAll(seaWhite),
      );

  BorderSide get outlineBorder => BorderSide(color: raisinBlack, width: 0.3.r);

  UnderlineInputBorder underlineInputBorder(Color color) =>
      UnderlineInputBorder(borderSide: BorderSide(color: color, width: 0.9.r));
}
