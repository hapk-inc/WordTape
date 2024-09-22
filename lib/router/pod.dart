import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../ui/dashboard.dart';
import '../ui/outline.dart';
import '../ui/puzzle.dart';
import '../ui/renovation.dart';
import '../ui/splash.dart';
import '../model/date_ext.dart';

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

              return PuzzlePage(args.convert());
            },
          ),
        ],
      ),
    ],
  );
}

//flutter packages pub run build_runner build --delete-conflicting-outputs

//dart run build_runner build --delete-conflicting-outputs

//for freezed
//flutter pub run build_runner build --delete-conflicting-outputs

//flutter pub run flutter_native_splash:create

//gradle signingreport

//flutter build appbundle --flavor prod --no-tree-shake-icons

//dart run build_runner build

//dart run build_runner build --delete-conflicting-outputs
/*  # dart run flutter_native_splash:create --flavors Dev,Prod

  #  flutter build ipa --no-tree-shake-icons
  #  flutter build web --no-tree-shake-icons
  #  firebase deploy --no-tree-shake-icons
  # pod update "Firebase/CoreOnly"

  # dart run build_runner watch
  # dart run flutter_native_splash:create

  # flutter build apk --release --target=lib/main_dev.dart

  # flutter build web --web-renderer canvaskit

  # console check : firebase_auth.getAuth().currentUser.uid
  # #/privacy-policy-route

  # flutter build web --web-renderer canvaskit --target=lib/main_web.dart

  # https://github.com/rrousselGit/riverpod/tree/master/packages/riverpod_lint#provider_dependencies-riverpod_generator-only*/
