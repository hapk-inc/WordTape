import 'package:device_preview/device_preview.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'router/my_route.dart';
import 'theme/my_theme_data.dart';

final MyRouter _router = MyRouter();

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  //late MyRouter myRouter;

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        designSize: const Size(360, 900),
        useInheritedMediaQuery: true,
        builder: (_, __) => GetMaterialApp.router(
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          theme: buildThemeData(),

          //router
          //routerConfig: _router.config(),
          routeInformationParser: _router.defaultRouteParser(),
          routerDelegate: _router.delegate(),
        ),
      );
}
