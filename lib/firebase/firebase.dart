import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase.g.dart';

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
