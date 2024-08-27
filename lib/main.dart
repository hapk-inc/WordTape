import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'firebase/firebase.dart';
import 'firebase/firebase_option_dev.dart';
import 'firebase/firebase_option_prod.dart';
import 'logic/dot_env.dart';
import 'logic/size.dart';
import 'router/my_router.dart';
import 'ui/theme/colors.dart';
import 'ui/theme/font_function.dart';

//import 'package:web/web.dart' as web;

// m for mobile, t for tablet, p or pc

//final DefaultTextTheme textTheme = DefaultTextTheme();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.addPostFrameCallback((_) => debugPrint("36=="));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  final FirebaseOptions dev = DefaultFirebaseOptionsDev.currentPlatform;
  final FirebaseOptions prod = DefaultFirebaseOptionsProd.currentPlatform;

  //String url = kIsWeb ? web.window.location.href : "";
  String url = "";
  final FirebaseApp app = await Firebase.initializeApp(
    options: kDebugMode
        ? dev
        : kIsWeb && url.contains('demo')
            ? dev
            : prod,
  );

  final FirebaseAuth firebaseAuth = FirebaseAuth.instanceFor(app: app);
  final FirebaseFirestore fireStore = FirebaseFirestore.instanceFor(app: app);

  //
  final FirebaseAnalytics analytics = FirebaseAnalytics.instanceFor(app: app);

/*  if (kIsWeb) {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    WebBrowserInfo webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;
    String? deviceName = _retrieveDeviceName(webBrowserInfo.appVersion);
    if (deviceName != null) {
      analytics.setUserProperty(name: 'device', value: deviceName);
    }
  }*/

  final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  final FirebaseRemoteConfig remoteConfig =
      FirebaseRemoteConfig.instanceFor(app: app);

  //await remoteConfig.setDefaults(remoteConfigDefaults);

  final RemoteConfigSettings remoteConfigSetting = RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 45),
    minimumFetchInterval: const Duration(seconds: 3),
  );

  await remoteConfig.setConfigSettings(remoteConfigSetting);

  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (!kIsWeb) {
      log("TAPE ERROR");
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stack);

      if (!kDebugMode) crashlytics.recordError(error, stack, fatal: true);
    } else {
      log("ERROR==");
      debugPrintStack(stackTrace: stack);
    }
    return true;
  };

  if (!kIsWeb) await crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);

  debugPrint("Firebase initialisation done");

  final List<Override> override = [
    firebaseAppProvider.overrideWithValue(app),
    firebaseAuthProvider.overrideWithValue(firebaseAuth),
    firebaseFirestoreProvider.overrideWithValue(fireStore),
    firebaseAnalyticsProvider.overrideWithValue(analytics),
    //
    remoteConfigProvider.overrideWithValue(remoteConfig),
    if (!kIsWeb) crashlyticsProvider.overrideWithValue(crashlytics),
    envProvider.overrideWithValue(dotenv..load(fileName: "assets/.env")),
  ];
  runApp(
    ProviderScope(
      overrides: override,
      child: DevicePreview(enabled: false, builder: (_) => const MyApp()),
    ),
  );
}

//MyRouter _router = MyRouter();

class MyApp extends ConsumerWidget with CustomThemeMixin {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MyRouter router = ref.read(routerProvider);
    return DevicePreview(
      builder: (_) => ScreenUtilInit(
        designSize: const Size(360, 900),
        builder: (_, __) {
          final String size = validateSize();

          return ProviderScope(
            overrides: [sizeProvider.overrideWithValue(size)],
            child: MaterialApp.router(
              theme: ThemeData(
                iconTheme: iconThemeData,
                textTheme: defaultTextTheme,
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: defaultButtonStyle.copyWith(
                    backgroundColor: const WidgetStatePropertyAll(blackBean),
                  ),
                ),
                outlinedButtonTheme: OutlinedButtonThemeData(
                  style: defaultButtonStyle.copyWith(
                    side: WidgetStatePropertyAll(outlineBorder),
                  ),
                ),
              ),
              routeInformationParser: router.defaultRouteParser(),
              routerDelegate: router.delegate(),
            ),
          );
        },
      ),
    );
  }

  String validateSize() {
    final double mW = 360.w;
    if (mW < 420.r) return 'mobile';
    return mW < 720.r ? 'tab' : 'pc';
  }
}

mixin CustomThemeMixin {
  IconThemeData get iconThemeData => IconThemeData(
        size: 18.r,
        color: slateGray,
      );

  TextTheme get defaultTextTheme => DefaultTextTheme();

  ButtonStyle get defaultButtonStyle => ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
        ),
        textStyle: WidgetStatePropertyAll(defaultTextTheme.bodySmall),
        minimumSize: WidgetStatePropertyAll(Size(60.r, 54.r)),
        elevation: WidgetStatePropertyAll(4.5.r),
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 30.r)),
        foregroundColor: const WidgetStatePropertyAll(seaWhite),
      );

  BorderSide get outlineBorder => BorderSide(color: raisinBlack, width: 0.45.r);
}
