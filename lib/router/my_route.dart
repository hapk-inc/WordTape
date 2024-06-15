import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';

import '../ui/dashboard.dart';
import '../ui/app_stack.dart';
import '../ui/how_to_play.dart';
import '../ui/privacy_policy.dart';
import '../ui/puzzle_board.dart';
import '../model/puzzle.dart';
import 'package:flutter/material.dart';
part 'my_route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class MyRouter extends _$MyRouter {
  //final User? fUser;

  MyRouter() : super(navigatorKey: Get.key);
  //MyRouter({this.fUser});

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: AppStackRoute.page,
          initial: true,
          path: '/',
          children: [
            AutoRoute(page: DashboardRoute.page, initial: true, path: 'home'),
            AutoRoute(page: PuzzleBoardRoute.page, path: 'daily-challenge'),
            AutoRoute(page: HowToPlayRoute.page, path: 'instructions'),
            AutoRoute(page: PrivacyPolicyRoute.page, path: 'privacy-policy'),
          ],
        )
      ];
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
