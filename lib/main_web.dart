import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/web.dart';

import 'package:web/web.dart' as web;

import 'enum/enum.dart';
import 'firebase/pod.dart';
import 'firebase/firebase_option_dev.dart';
import 'firebase/firebase_option_prod.dart';
import 'app.dart';
import 'function/connectivity/pod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  WidgetsBinding.instance.addPostFrameCallback((_) {});
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  final FirebaseOptions dev = DefaultFirebaseOptionsDev.currentPlatform;
  final FirebaseOptions prod = DefaultFirebaseOptionsProd.currentPlatform;

  final String url = web.window.location.href;

  final AppEnv appEnv = kDebugMode
      ? AppEnv.dev
      : kIsWeb && url.contains('demo')
          ? AppEnv.dev
          : AppEnv.prod;

  final FirebaseOptions options = appEnv == AppEnv.dev ? dev : prod;

  final FirebaseApp app = await Firebase.initializeApp(options: options);

  final FirebaseAuth firebaseAuth = FirebaseAuth.instanceFor(app: app);
  final FirebaseFirestore firebaseFirestore =
      FirebaseFirestore.instanceFor(app: app);
  firebaseFirestore.settings = Settings(webExperimentalForceLongPolling: true);
  final FirebaseRemoteConfig remoteConfig =
      FirebaseRemoteConfig.instanceFor(app: app);

  final FirebaseAnalytics firebaseAnalytics =
      FirebaseAnalytics.instanceFor(app: app);

  final RemoteConfigSettings remoteConfigSetting = RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 45),
    minimumFetchInterval: const Duration(seconds: 3),
  );

  remoteConfig.setDefaults(<String, dynamic>{"renovation": ""});
  await remoteConfig.setConfigSettings(remoteConfigSetting);

  final Logger tracker = Logger();

  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    tracker.e("WEB CRASH", error: error, stackTrace: stack);
    firebaseFirestore.collection('errors').add(<String, dynamic>{
      "error": FieldValue.arrayUnion([
        {"error": error, "stacktrace": stack}
      ])
    });

    return true;
  };

  final Connectivity connectivity = Connectivity();
  final List<ConnectivityResult> connectivityResult =
      await connectivity.checkConnectivity();

  final bool isValid = connectivityResult.contains(ConnectivityResult.mobile) ||
      connectivityResult.contains(ConnectivityResult.wifi);
  int validConnection = 0;
  if (isValid) {
    validConnection = await remoteConfig.fetchAndActivate().then(
          (flag) => flag ? 1 : 0,
        );
  } else {
    validConnection = -1;
  }

  final List<Override> override = [
    firebaseAppProvider.overrideWithValue(app),
    firebaseAuthProvider.overrideWithValue(firebaseAuth),
    firestoreProvider.overrideWithValue(firebaseFirestore),
    firebaseAnalyticsProvider.overrideWithValue(firebaseAnalytics),
    //
    remoteConfigProvider.overrideWithValue(remoteConfig),
    envProvider.overrideWithValue(dotenv..load(fileName: "assets/env")),
    //
    trackerProvider.overrideWithValue(tracker),

    appEnvProvider.overrideWithValue(appEnv),

    validateConnectionProvider.call(value: validConnection)
  ];
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/locale',
      child: ProviderScope(
        overrides: override,
        child: DevicePreview(enabled: false, builder: (_) => const App()),
      ),
    ),
  );
}
