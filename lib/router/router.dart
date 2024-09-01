import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../remote/config.dart';
import '../ui/login.dart';
import '../ui/outline.dart';
import '../ui/renovation.dart';
import '../ui/splash.dart';

part 'router.g.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true, dependencies: [renovation])
GoRouter router(RouterRef ref) {
  return GoRouter(
    redirect: (_, state) async {
      final String str = ref.read(renovationProvider).value ?? "";
      if (str.isNotEmpty) return '/renovation';
      return '/';
    },
    routes: <RouteBase>[
      ShellRoute(
        navigatorKey: navigatorKey,
        builder: (_, __, child) => OutlinePage(child),
        routes: [
          GoRoute(path: '/', builder: (_, state) => const SplashPage()),
          GoRoute(path: '/login', builder: (_, state) => const LoginPage()),
          GoRoute(
            path: '/renovation',
            builder: (_, state) => const RenovationPage(),
          ),
        ],
      ),
    ],
  );
}
