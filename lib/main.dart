import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //
  //final PackageInfo info = await PackageInfo.fromPlatform();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  final FirebaseApp app = await Firebase.initializeApp(
    options: kDebugMode
        ? DefaultFirebaseOptionsDev.currentPlatform
        : DefaultFirebaseOptionsProd.currentPlatform,
  );

  final FirebaseAuth firebaseAuth = FirebaseAuth.instanceFor(app: app);
  final FirebaseFirestore fireStore = FirebaseFirestore.instanceFor(app: app);

  List<Override> overrides = [
    firebaseAppProvider.overrideWithValue(app),
    firebaseAuthProvider.overrideWithValue(firebaseAuth),
    firebaseFirestoreProvider.overrideWithValue(fireStore),
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
