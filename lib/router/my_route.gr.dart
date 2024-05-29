// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'my_route.dart';

abstract class _$MyRouter extends RootStackRouter {
  // ignore: unused_element
  _$MyRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AppStackRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AppStackPage(),
      );
    },
    DashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DashboardPage(),
      );
    },
    PuzzleBoardRoute.name: (routeData) {
      final args = routeData.argsAs<PuzzleBoardRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PuzzleBoardPage(
          args.puzzle,
          key: args.key,
        ),
      );
    },
  };
}

/// generated route for
/// [AppStackPage]
class AppStackRoute extends PageRouteInfo<void> {
  const AppStackRoute({List<PageRouteInfo>? children})
      : super(
          AppStackRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppStackRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DashboardPage]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PuzzleBoardPage]
class PuzzleBoardRoute extends PageRouteInfo<PuzzleBoardRouteArgs> {
  PuzzleBoardRoute({
    required Puzzle puzzle,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          PuzzleBoardRoute.name,
          args: PuzzleBoardRouteArgs(
            puzzle: puzzle,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'PuzzleBoardRoute';

  static const PageInfo<PuzzleBoardRouteArgs> page =
      PageInfo<PuzzleBoardRouteArgs>(name);
}

class PuzzleBoardRouteArgs {
  const PuzzleBoardRouteArgs({
    required this.puzzle,
    this.key,
  });

  final Puzzle puzzle;

  final Key? key;

  @override
  String toString() {
    return 'PuzzleBoardRouteArgs{puzzle: $puzzle, key: $key}';
  }
}
