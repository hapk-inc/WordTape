import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../function/question/toast.dart';
import '../model/route_path.dart';
import '../panel/pod.dart';
import '../remote_config/pod.dart';
import '../ui/dashboard.dart';
import '../ui/outline.dart';
import '../ui/renovation.dart';
import '../ui/riddle.dart';
import '../ui/splash.dart';
import 'path.dart';

part 'router.g.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldKey =
    GlobalKey<ScaffoldMessengerState>();

@Riverpod(
  keepAlive: true,
  dependencies: [
    renovation,
    PathNotifier,
    panelController,
    ToastNotifier,
  ],
)
GoRouter router(Ref ref) => GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: "/",
      routes: <RouteBase>[
        ShellRoute(
          redirect: (_, state) async {
            print("40--ShellRoute Redirect");
            print(state.matchedLocation);
            final String? renovation =
                await ref.read(renovationProvider.future);
            if (renovation?.isNotEmpty ?? false) return "/renovation";

            //
            final RoutePath path = ref.read(pathNotifierProvider);
            ref.read(pathNotifierProvider.notifier).state = path.copyWith(
              path: state.matchedLocation,
            );
            print(ref.read(pathNotifierProvider).path);

            if (state.pathParameters.containsKey('date')) {
              final String? str = state.pathParameters['date'];
              DateTime dateTime = DateFormat("dd-MMM-yyyy").parse(str!);
              ref.read(pathNotifierProvider.notifier).state =
                  path.copyWith(date: dateTime);
            }

            return state.matchedLocation;
          },
          builder: (_, __, child) => OutlinePage(child),
          routes: [
            GoRoute(path: '/', builder: (_, __) => const SplashPage()),
            GoRoute(
              path: '/renovation',
              builder: (_, __) => const RenovationPage(),
            ),
            GoRoute(
              path: '/daily-challenge',
              builder: (_, __) => const DashboardPage(),
            ),
            GoRoute(
              path: '/daily-challenge/:date',
              builder: (_, GoRouterState state) {
                final String? str = state.pathParameters['date'];
                DateTime dateTime = DateFormat("dd-MMM-yyyy").parse(str!);
                return RiddlePage(dateTime);
              },
              onExit: (_, state) {
                ref.read(panelNotifierProvider.notifier).state = null;
                ref.read(toastNotifierProvider.notifier).closingIfOpen();
                final RoutePath path = ref.read(pathNotifierProvider);

                ref.read(pathNotifierProvider.notifier).state =
                    path.copyWith(path: "/daily-challenge");
                return true;
              },
            ),
          ],
        ),
      ],
    );

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
