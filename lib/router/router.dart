import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wordtape/function/question/notifier.dart';
import 'package:wordtape/panel/pod.dart';

// import '../function/local/pod.dart';

import '../function/date_selected/date_selected.dart';
import '../model/route_path.dart';
import '../remote_config/pod.dart';
import '../ui/dashboard.dart';
import '../ui/outline.dart';
import '../ui/renovation.dart';
import '../ui/riddle.dart';
import '../ui/splash.dart';
import 'path.dart';

part 'router.g.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@Riverpod(
  keepAlive: true,
  dependencies: [renovation, DateSelected, PathNotifier, panelController],
)
GoRouter router(RouterRef ref) {
  return GoRouter(
    redirect: (_, state) async {
      final String? renovation = await ref.read(renovationProvider.future);
      if (renovation?.isNotEmpty ?? false) return "/renovation";

      //
      final RoutePath path = ref.read(pathNotifierProvider);
      ref.read(pathNotifierProvider.notifier).state = path.copyWith(
        path: state.matchedLocation,
      );

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
          GoRoute(
            path: '/home',
            builder: (_, __) => const DashboardPage(),
          ),
          GoRoute(
            path: '/decode',
            builder: (_, GoRouterState state) {
              if (state.extra == null) {
                final DateTime args = ref.read(dateSelectedProvider);
                return RiddlePage(args);
              }
              final DateTime args = state.extra as DateTime;
              return RiddlePage(args);
            },
            onExit: (_, state) {
              final PanelController panelController =
                  ref.read(panelControllerProvider);
              if (panelController.isAttached) {
                if (panelController.isPanelOpen) panelController.close();
              }

              //
              final DateTime date = ref.read(dateSelectedProvider);
              final RoutePath path = ref.read(pathNotifierProvider);

              //
              // final QuestionNotifier questionNotifier =
              //    ref.read(questionNotifierProvider(date));
              // questionNotifier.insert();
              ref.read(pathNotifierProvider.notifier).state = path.copyWith(
                path: "/home",
              );
              return true;
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
