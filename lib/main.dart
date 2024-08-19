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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'firebase/firebase.dart';
import 'firebase/firebase_option_dev.dart';
import 'firebase/firebase_option_prod.dart';
import 'logic/size.dart';
import 'outline.dart';
import 'ui/theme/colors.dart';
import 'ui/theme/font_function.dart';

//import 'package:web/web.dart' as web;

// m for mobile, t for tablet, p or pc

final DefaultTextTheme textTheme = DefaultTextTheme();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      crashlytics.recordError(error, stack, fatal: true);
    } else {
      debugPrint("75--Error");
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
  ];
  runApp(
    ProviderScope(
      overrides: override,
      child: DevicePreview(
        enabled: false,
        //enabled: kIsWeb ? false : defaultTargetPlatform == TargetPlatform.macOS,
        builder: (_) => const MyApp(),
      ),
    ),
  );
}

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
                iconTheme: IconThemeData(size: 21.r, color: raisinBlack),
                textTheme: textTheme,
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    foregroundColor: const WidgetStatePropertyAll(seaWhite),
                    backgroundColor: const WidgetStatePropertyAll(blackBean),
                    textStyle: WidgetStatePropertyAll(textTheme.bodySmall),
                    minimumSize: WidgetStatePropertyAll(Size(60.r, 54.r)),
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
                    textStyle: WidgetStatePropertyAll(textTheme.bodySmall),
                    minimumSize: WidgetStatePropertyAll(Size(60.r, 54.r)),
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
