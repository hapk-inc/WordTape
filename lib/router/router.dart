import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wordtape/ui/summary.dart';

import '../function/riddle/notifier.dart';
import '../function/sqlite/pod.dart';
import '../model/found.dart';
import '../panel/pod.dart';
import '../ui/common/logoff.dart';
import '../ui/dashboard.dart';
import '../ui/outline.dart';
import '../ui/riddle.dart';
// import '../ui/renovation.dart';
import '../ui/splash.dart';

part 'router.g.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true, dependencies: [sqFound])
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
          GoRoute(path: '/home', builder: (_, __) => const DashboardPage()),
          GoRoute(
            path: '/riddle',
            redirect: (context, state) {
              log("35==Redirect");
              final DateTime args = state.extra as DateTime;
              final RiddleNotifier notifier =
                  ref.read(riddleNotifierProvider(args));
              if (notifier.done) {
                ref.read(panelNotifierProvider.notifier).state =
                    const LogoffAlert();
              }
              return state.matchedLocation;
            },
            builder: (_, GoRouterState state) {
              final DateTime args = state.extra as DateTime;
              return RiddlePage(args);
            },
            onExit: (_, state) {
              final DateTime date = state.extra as DateTime;
              final Found found = ref.read(riddleNotifierProvider(date)).found;
              ref.read(sqFoundProvider).insert(found);
              return true;
            },
          ),
          GoRoute(
            path: '/summary',
            //builder: (_, state) => const SummaryPage(),
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                child: const SummaryPage(),
                transitionsBuilder: (_, animation, __, child) {
                  const Offset begin = Offset(0.0, 1.0);
                  const Offset end =
                      Offset.zero; // End at the original position
                  const curve = Curves.easeInOut;

                  final Animatable<Offset> tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  final Animation<Offset> anim = animation.drive(tween);

                  return SlideTransition(position: anim, child: child);
                },
              );
            },
          )
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
