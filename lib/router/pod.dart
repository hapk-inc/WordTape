import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../logic/remote/pod.dart';
import '../ui/dashboard.dart';
import '../ui/login.dart';
import '../ui/outline.dart';
import '../ui/renovation.dart';
import '../ui/splash.dart';

part 'pod.g.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true, dependencies: [renovation])
GoRouter router(RouterRef ref) {
  return GoRouter(
    redirect: (_, state) async {
      log("Redirection");
      final String str = ref.read(renovationProvider).value ?? "";
      if (str.isNotEmpty) return '/renovation';
      return state.matchedLocation;
      //return '/renovation';
    },
    routes: <RouteBase>[
      ShellRoute(
        navigatorKey: navigatorKey,
        builder: (_, __, child) => OutlinePage(child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const SplashPage()),
          GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
          GoRoute(
            path: '/renovation',
            builder: (_, __) => const RenovationPage(),
          ),
          GoRoute(
            path: '/home',
            builder: (_, __) => const DashboardPage(),
          )
        ],
      ),
    ],
  );
}
