import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../function/date/date.dart';
import '../function/local/pod.dart';
import '../function/question/notifier.dart';

import '../model/found.dart';

import '../remote_config/pod.dart';
import '../ui/dashboard.dart';
import '../ui/outline.dart';
import '../ui/renovation.dart';
import '../ui/riddle.dart';
import '../ui/splash.dart';
import '../ui/summary.dart';

part 'router.g.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true, dependencies: [renovation, localFound, SelectedDate])
GoRouter router(RouterRef ref) {
  return GoRouter(
    redirect: (_, state) async {
      final String? renovation = await ref.read(renovationProvider.future);
      debugPrint("27==$renovation");
      if (renovation?.isNotEmpty ?? false) return "/renovation";
      return state.matchedLocation;
    },
    routes: <RouteBase>[
      ShellRoute(
        navigatorKey: navigatorKey,
        builder: (_, __, child) => OutlinePage(child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const SplashPage()),
          GoRoute(
            path: '/renovation',
            builder: (_, __) => const RenovationPage(),
          ),
          GoRoute(path: '/home', builder: (_, __) => const DashboardPage()),
          GoRoute(
            path: '/riddle',
            builder: (_, GoRouterState state) {
              if (state.extra == null) {
                final DateTime args = ref.read(selectedDateProvider);
                return RiddlePage(args);
              }
              final DateTime args = state.extra as DateTime;
              return RiddlePage(args);
            },
            onExit: (_, state) {
              DateTime date;
              if (state.extra == null) {
                date = ref.read(selectedDateProvider);
              } else {
                date = state.extra as DateTime;
              }

              final Found found =
                  ref.read(questionNotifierProvider(date)).found;
              ref.read(localFoundProvider).insert(found);
              return true;
            },
          ),
          GoRoute(
            path: '/summary',
            pageBuilder: (context, state) {
              final DateTime? args = state.extra as DateTime?;
              return CustomTransitionPage(
                child: args == null ? Container() : SummaryPage(date: args),
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
