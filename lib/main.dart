import 'dart:io';

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

import 'app.dart';
import 'firebase/firebase.dart';
import 'firebase/firebase_options_dev.dart';
import 'firebase/firebase_options_prod.dart';

//import 'package:device_info_plus/device_info_plus.dart';

//import 'package:web/web.dart' as web;
const String iphone = "iPhone";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  final FirebaseOptions dev = DefaultFirebaseOptionsDev.currentPlatform;
  final FirebaseOptions prod = DefaultFirebaseOptionsProd.currentPlatform;

  //final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  //String url = kIsWeb ? web.window.location.href : "";
  String url = "";
  debugPrint(url);

  //bool androidWeb = false;
  //bool isEmulator = true;
  //bool isModelPhone = false;

  ///Uri.base.path;
  final FirebaseApp app = await Firebase.initializeApp(
    options: kDebugMode
        ? dev
        : kIsWeb && url.contains('demo')
            ? dev
            : prod,
  );

  // String? deviceName;
  if (!kIsWeb) {
    if (Platform.isAndroid) {
      //final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      //isEmulator = !androidInfo.isPhysicalDevice;
    } else if (Platform.isIOS) {
      //final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      //isModelPhone = iosInfo.model == iphone;
      //isEmulator = !iosInfo.isPhysicalDevice;
    } else if (Platform.isMacOS) {
      //final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      //_log.d("${packageInfo.data}");
    }
  } else {
    //WebBrowserInfo webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;

    //Retrieve Device Name
    // deviceName = retrieveDeviceName(webBrowserInfo.appVersion);

    //Validate android web
    //androidWeb = (webBrowserInfo.appVersion ?? "").contains('Android');
  }

/*  if (deviceName != null) {
    analytics.setUserProperty(name: 'device', value: deviceName);
  }*/

  runApp(
    ProviderScope(
      overrides: await _initFirebase(app),
      child: DevicePreview(
        enabled: kIsWeb ? false : Platform.isMacOS,
        builder: (_) => const MyApp(),
      ),
    ),
  );
}

String? retrieveDeviceName(String? appVersion) {
  if (appVersion == null) return null;

  // Regular expression to match content within the first set of parentheses
  RegExp pattern = RegExp(r'\(([^)]+)\)');

  // Search for the pattern
  RegExpMatch? match = pattern.firstMatch(appVersion);

  // Extract and print the first match
  if (match != null) {
    String r = match.group(1)!;
    debugPrint("96--$r");
    return r;
  } else {
    return null;
  }
}

Future<List<Override>> _initFirebase(FirebaseApp app) async {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instanceFor(app: app);
  final FirebaseFirestore fireStore = FirebaseFirestore.instanceFor(app: app);

  //
  final FirebaseAnalytics analytics = FirebaseAnalytics.instanceFor(app: app);

  final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  final FirebaseRemoteConfig rc = FirebaseRemoteConfig.instanceFor(app: app);

  //await remoteConfig.setDefaults(remoteConfigDefaults);

  final RemoteConfigSettings remoteConfigSetting = RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 45),
    minimumFetchInterval: const Duration(seconds: 3),
  );

  await rc.setConfigSettings(remoteConfigSetting);

  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    //_log.e(error, stackTrace: stack);
    if (!kIsWeb) {
      crashlytics.recordError(error, stack, fatal: true);
    }
    return true;
  };

  if (!kIsWeb) {
    await crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
  }

  return [
    firebaseAppProvider.overrideWithValue(app),
    firebaseAuthProvider.overrideWithValue(firebaseAuth),
    firebaseFirestoreProvider.overrideWithValue(fireStore),
    firebaseAnalyticsProvider.overrideWithValue(analytics),
    //
    remoteConfigProvider.overrideWithValue(rc),
    if (!kIsWeb) crashlyticsProvider.overrideWithValue(crashlytics),
  ];
}
