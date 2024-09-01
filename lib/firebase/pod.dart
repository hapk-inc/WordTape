import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true)
FirebaseApp firebaseApp(FirebaseAppRef ref) => throw UnimplementedError();

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) => throw UnimplementedError();

@Riverpod(keepAlive: true)
FirebaseAnalytics firebaseAnalytics(FirebaseAnalyticsRef ref) =>
    throw UnimplementedError();

@Riverpod(keepAlive: true)
FirebaseFirestore firestore(FirestoreRef ref) => throw UnimplementedError();

@Riverpod(keepAlive: true, dependencies: [])
FirebaseRemoteConfig remoteConfig(RemoteConfigRef ref) =>
    throw UnimplementedError();

@Riverpod(keepAlive: true)
FirebaseCrashlytics crashlytics(CrashlyticsRef ref) =>
    throw UnimplementedError();
