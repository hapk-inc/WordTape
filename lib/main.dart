import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'firebase/firebase.dart';
import 'firebase/firebase_options_dev.dart';
import 'firebase/firebase_options_prod.dart';

import 'package:device_info_plus/device_info_plus.dart';

import 'package:web/web.dart' as web;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  final FirebaseOptions dev = DefaultFirebaseOptionsDev.currentPlatform;
  final FirebaseOptions prod = DefaultFirebaseOptionsProd.currentPlatform;

  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  String url = kIsWeb ? web.window.location.href : "";
  //String url = "";
  debugPrint(url);

  bool androidWeb = false;

  ///Uri.base.path;
  final FirebaseApp app = await Firebase.initializeApp(
    options: kDebugMode
        ? dev
        : kIsWeb && url.contains('demo')
            ? dev
            : prod,
  );

  String? deviceName;
  if (!kIsWeb) {
  } else {
    WebBrowserInfo webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;

    //Retrieve Device Name
    deviceName = retrieveDeviceName(webBrowserInfo.appVersion);

    //Validate android web
    androidWeb = (webBrowserInfo.appVersion ?? "").contains('Android');
    debugPrint('AndroidWeb $androidWeb');
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instanceFor(app: app);
  final FirebaseFirestore fireStore = FirebaseFirestore.instanceFor(app: app);

  //
  final FirebaseAnalytics analytics = FirebaseAnalytics.instanceFor(app: app);
  if (deviceName != null) {
    analytics.setUserProperty(name: 'device', value: deviceName);
  }

  List<Override> overrides = [
    firebaseAppProvider.overrideWithValue(app),
    firebaseAuthProvider.overrideWithValue(firebaseAuth),
    firebaseFirestoreProvider.overrideWithValue(fireStore),
    firebaseAnalyticsProvider.overrideWithValue(analytics),
  ];

  runApp(
    ProviderScope(
      overrides: overrides,
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
