import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: OutlineRoute.page,
          initial: true,
          children: [
            CustomRoute(
              page: LoginRoute.page,
              transitionsBuilder: TransitionsBuilders.noTransition,
              //initial: true,
              maintainState: false,
            ),
            CustomRoute(
              //path: '/',
              page: DashboardRoute.page,
              transitionsBuilder: TransitionsBuilders.noTransition,
              initial: true,
              maintainState: false,
            ),
            CustomRoute(
              page: PuzzleRoute.page,
              path: ':id',
              transitionsBuilder: TransitionsBuilders.slideBottom,
              durationInMilliseconds: 150,
              maintainState: false,
            ),
          ],
        ),
      ];

  @override
  List<AutoRouteGuard> get guards => [
        // optionally add root guards here
      ];
}
