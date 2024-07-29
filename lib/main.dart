import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'ui/home.dart';
import 'ui/theme/text_theme.dart';

// m for mobile, t for tablet, p or pc

Future<void> main() async => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => DevicePreview(
        builder: (_) => ScreenUtilInit(
          designSize: const Size(360, 900),
          builder: (_, __) {
            String size = 360.w < 420.r
                ? 'mobile'
                : 360.w < 720.r
                    ? 'tab'
                    : 'pc';

            return MaterialApp(
              theme: ThemeData(textTheme: DefaultTextTheme()),
              home: HomePage(size),
            );
          },
        ),
      );
}
