import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true)
FirebaseApp firebaseApp(Ref<FirebaseApp> ref) => throw UnimplementedError();

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref<FirebaseAuth> ref) => throw UnimplementedError();

@Riverpod(keepAlive: true)
FirebaseAnalytics firebaseAnalytics(Ref<FirebaseAnalytics> ref) =>
    throw UnimplementedError();

@Riverpod(keepAlive: true)
FirebaseFirestore firestore(Ref<FirebaseFirestore> ref) =>
    throw UnimplementedError();

@Riverpod(keepAlive: true, dependencies: [])
FirebaseRemoteConfig remoteConfig(Ref<FirebaseRemoteConfig> ref) =>
    throw UnimplementedError();

@Riverpod(keepAlive: true)
FirebaseCrashlytics crashlytics(Ref<FirebaseCrashlytics> ref) =>
    throw UnimplementedError();

@Riverpod(keepAlive: true, dependencies: [])
DotEnv env(Ref<DotEnv> ref) => throw UnimplementedError();
