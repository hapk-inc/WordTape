import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../outline.dart';
import '../ui/splash.dart';
import '../ui/dashboard.dart';
import '../ui/login.dart';
import '../ui/puzzle.dart';
import 'guards/auth_guard.dart';

part 'my_router.gr.dart';

final ChangeNotifierProvider<MyRouter> routerProvider =
    ChangeNotifierProvider<MyRouter>((ref) => MyRouter(ref));

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class MyRouter extends RootStackRouter {
  final Ref ref;
  MyRouter(this.ref);

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: OutlineRoute.page,
          initial: true,
          children: [
            CustomRoute(
              page: SplashRoute.page,
              initial: true,
              barrierLabel: "BarrierLabel",
              guards: [AuthGuard(ref)],
            ),
            CustomRoute(
              page: LoginRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              durationInMilliseconds: 750,
              maintainState: false,
            ),
            CustomRoute(
              //path: '/',
              page: DashboardRoute.page,
              transitionsBuilder: TransitionsBuilders.noTransition,

              //maintainState: false,
            ),
            CustomRoute(
              page: PuzzleRoute.page,
              path: ':id',
              transitionsBuilder: TransitionsBuilders.slideBottom,
              durationInMilliseconds: 150,
              //maintainState: false,
            ),
          ],
        ),
      ];

  @override
  List<AutoRouteGuard> get guards => [];
}
