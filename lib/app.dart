import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'enum/pod.dart';
import 'router/pod.dart';
import 'ui/theme/color.dart';
import 'ui/theme/font.dart';

class MyApp extends ConsumerWidget with CustomThemeMixin {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.read(routerProvider);
    return ScreenUtilInit(
      designSize: const Size(360, 900),
      builder: (context, child) {
        final ScreenSize size = validateSize();
        return ProviderScope(
          overrides: [sizeProvider.overrideWithValue(size)],
          child: MaterialApp.router(
            theme: ThemeData(
              iconTheme: iconThemeData,
              textTheme: defaultTextTheme,
              inputDecorationTheme: InputDecorationTheme(
                enabledBorder: underlineInputBorder(mint),
                focusedBorder: underlineInputBorder(seaWhite),
                errorBorder: underlineInputBorder(cerise),
                focusedErrorBorder: underlineInputBorder(cerise),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: defaultButtonStyle.copyWith(
                  backgroundColor: const WidgetStatePropertyAll(blackBean),
                ),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: defaultButtonStyle.copyWith(
                    side: WidgetStatePropertyAll(outlineBorder),
                    foregroundColor: const WidgetStatePropertyAll(raisinBlack)),
              ),
            ),
            routerConfig: router,
          ),
        );
      },
    );
  }
}

mixin CustomThemeMixin {
  IconThemeData get iconThemeData => IconThemeData(
        size: 18.r,
        color: slateGray,
      );

  TextTheme get defaultTextTheme => DefaultTextTheme();

  ButtonStyle get defaultButtonStyle => ButtonStyle(
        elevation: WidgetStatePropertyAll(1.5.r),
        textStyle: WidgetStatePropertyAll(defaultTextTheme.bodySmall),
        minimumSize: WidgetStatePropertyAll(Size(150.r, 60.r)),
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 30.r)),
        foregroundColor: const WidgetStatePropertyAll(seaWhite),
      );

  BorderSide get outlineBorder => BorderSide(color: raisinBlack, width: 0.3.r);

  UnderlineInputBorder underlineInputBorder(Color color) =>
      UnderlineInputBorder(borderSide: BorderSide(color: color, width: 0.9.r));
}
