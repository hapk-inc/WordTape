import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../ui/dashboard.dart';
import '../ui/outline.dart';
import '../ui/puzzle.dart';
import '../ui/renovation.dart';
import '../ui/splash.dart';

part 'pod.g.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true, dependencies: [])
GoRouter router(RouterRef ref) {
  return GoRouter(
    redirect: (_, state) async {
      return state.matchedLocation;
    },
    routes: <RouteBase>[
      ShellRoute(
        navigatorKey: navigatorKey,
        builder: (_, __, child) => OutlinePage(child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const SplashPage()),
          //GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
          GoRoute(
            path: '/renovation',
            builder: (_, __) => const RenovationPage(),
          ),
          GoRoute(path: '/home', builder: (_, __) => const DashboardPage()),
          GoRoute(
            path: '/puzzle',
            builder: (_, GoRouterState state) {
              final DateTime args =
                  (state.extra as DateTime?) ?? DateTime.now();
              DateFormat formatter = DateFormat('yyyy-MM-dd');
              final String dateStr = formatter.format(args);
              DateTime formatted = formatter.parse(dateStr);
              return PuzzlePage(formatted);
            },
          ),
        ],
      ),
    ],
  );
}
