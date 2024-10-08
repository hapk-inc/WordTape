import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
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
import 'package:logger/logger.dart';

import 'enum/enum.dart';
import 'firebase/pod.dart';
import 'firebase/firebase_option_dev.dart';
import 'firebase/firebase_option_prod.dart';
import 'app.dart';
import 'logger/log.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  //
  WidgetsBinding.instance.addPostFrameCallback((_) {});
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  final FirebaseOptions dev = DefaultFirebaseOptionsDev.currentPlatform;
  final FirebaseOptions prod = DefaultFirebaseOptionsProd.currentPlatform;

  const AppEnv appEnv = kDebugMode ? AppEnv.dev : AppEnv.prod;

  final FirebaseApp app = await Firebase.initializeApp(
    options: appEnv == AppEnv.dev ? dev : prod,
  );

  final FirebaseAuth firebaseAuth = FirebaseAuth.instanceFor(app: app);
  final FirebaseFirestore fireStore = FirebaseFirestore.instanceFor(app: app);
  final FirebaseRemoteConfig rc = FirebaseRemoteConfig.instanceFor(app: app);

  final FirebaseAnalytics analytics = FirebaseAnalytics.instanceFor(app: app);
  final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  final RemoteConfigSettings remoteConfigSetting = RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 45),
    minimumFetchInterval: const Duration(seconds: 3),
  );

  rc.setDefaults(<String, dynamic>{"renovation": ""});
  await rc.setConfigSettings(remoteConfigSetting);

  final Logger logger = Logger();

  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    logger.e("App Crash", error: error, stackTrace: stack);
    if (kReleaseMode) crashlytics.recordError(error, stack, fatal: true);
    return true;
  };

  await crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);

  logger.i("FIREBASE STARTED");

  final List<Override> override = [
    firebaseAppProvider.overrideWithValue(app),
    firebaseAuthProvider.overrideWithValue(firebaseAuth),
    firestoreProvider.overrideWithValue(fireStore),
    firebaseAnalyticsProvider.overrideWithValue(analytics),
    //
    remoteConfigProvider.overrideWithValue(rc),
    crashlyticsProvider.overrideWithValue(crashlytics),
    envProvider.overrideWithValue(dotenv..load(fileName: "assets/.env")),
    //
    logProvider.overrideWithValue(logger),
    //
    appEnvProvider.overrideWithValue(appEnv)
  ];
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/locale',
      child: ProviderScope(
        overrides: override,
        child: DevicePreview(enabled: kDebugMode, builder: (_) => const App()),
      ),
    ),
  );
}
