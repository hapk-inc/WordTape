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
            AutoRoute(page: LoginRoute.page),
            CustomRoute(
              page: DashboardRoute.page,
              transitionsBuilder: TransitionsBuilders.noTransition,
              initial: true,
            ),
            CustomRoute(
              page: PuzzleRoute.page,
              transitionsBuilder: TransitionsBuilders.slideBottom,
              durationInMilliseconds: 150,
            ),
          ],
        ),
      ];

  @override
  List<AutoRouteGuard> get guards => [
        // optionally add root guards here
      ];
}
