import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthGuard extends AutoRouteGuard {
  final User? user;
  User? fUser;

  AuthGuard(this.user);
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    debugPrint("12--${fUser?.uid}");
    resolver.next(true);
    //router.replace(LoginRoute());
  }
}
