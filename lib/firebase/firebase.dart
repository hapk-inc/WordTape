import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase.g.dart';

@riverpod
String helloWorld(HelloWorldRef ref) => 'Hello world';

@riverpod
FirebaseApp firebaseApp(FirebaseAppRef ref) => throw UnimplementedError();

@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) => throw UnimplementedError();

@riverpod
FirebaseFirestore firebaseFirestore(FirebaseFirestoreRef ref) =>
    throw UnimplementedError();

@riverpod
FirebaseAnalytics firebaseAnalytics(FirebaseAnalyticsRef ref) =>
    throw UnimplementedError();

@riverpod
FirebaseRemoteConfig remoteConfig(RemoteConfigRef ref) =>
    throw UnimplementedError();

@riverpod
FirebaseCrashlytics crashlytics(CrashlyticsRef ref) =>
    throw UnimplementedError();

String? _retrieveDeviceName(String? appVersion) {
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

Future<List<Override>> initFirebase(FirebaseApp app) async {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instanceFor(app: app);
  final FirebaseFirestore fireStore = FirebaseFirestore.instanceFor(app: app);

  //
  final FirebaseAnalytics analytics = FirebaseAnalytics.instanceFor(app: app);

  if (kIsWeb) {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    WebBrowserInfo webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;
    String? deviceName = _retrieveDeviceName(webBrowserInfo.appVersion);
    if (deviceName != null) {
      analytics.setUserProperty(name: 'device', value: deviceName);
    }
  }

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
    if (!kIsWeb) {
      crashlytics.recordError(error, stack, fatal: true);
    } else {
      debugPrint("75--Error");
      debugPrintStack(stackTrace: stack);
    }
    return true;
  };

  if (!kIsWeb) {
    await crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
  }

  debugPrint("Firebase initialisation done");

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
