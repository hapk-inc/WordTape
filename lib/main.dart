import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'logic/size.dart';
import 'outline.dart';
import 'ui/theme/colors.dart';
import 'ui/theme/font_function.dart';

// m for mobile, t for tablet, p or pc

final DefaultTextTheme textTheme = DefaultTextTheme();

Future<void> main() async => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => DevicePreview(
        builder: (_) => ScreenUtilInit(
          designSize: const Size(360, 900),
          builder: (_, __) {
            size = 360.w < 420.r
                ? 'mobile'
                : 360.w < 720.r
                    ? 'tab'
                    : 'pc';

            return MaterialApp(
              theme: ThemeData(
                textTheme: textTheme,
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    foregroundColor: const WidgetStatePropertyAll(seaWhite),
                    backgroundColor: const WidgetStatePropertyAll(seaWhite),
                    textStyle: WidgetStatePropertyAll(textTheme.bodyMedium),
                    minimumSize: WidgetStatePropertyAll(Size.square(60.r)),
                    elevation: WidgetStatePropertyAll(4.5.r),
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 30.r),
                    ),
                  ),
                ),
                outlinedButtonTheme: OutlinedButtonThemeData(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    side: WidgetStatePropertyAll(
                      BorderSide(color: raisinBlack, width: 0.45.r),
                    ),
                    elevation: WidgetStatePropertyAll(4.5.r),
                    foregroundColor: const WidgetStatePropertyAll(seaWhite),
                    textStyle: WidgetStatePropertyAll(textTheme.bodyMedium),
                    minimumSize: WidgetStatePropertyAll(Size.square(60.r)),
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 30.r),
                    ),
                  ),
                ),
              ),
              home: const OutlinePage(),
            );
          },
        ),
      );
}
