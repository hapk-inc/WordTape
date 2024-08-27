import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_notifier.dart';
import '../../enum/enum.dart';
import '../my_router.dart';

class AuthGuard extends AutoRouteGuard {
  final Ref ref;
  AuthGuard(this.ref);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) =>
      Future.delayed(
        const Duration(milliseconds: 150),
        () => validate(router),
      );

  validate(StackRouter router) {
    final AuthValidate validate = ref.read(authNotifierProvider).authValidate;
    switch (validate) {
      case AuthValidate.notLogged:
        {
          router.replace(const LoginRoute());
          break;
        }
      default:
        {
          router.replace(const DashboardRoute());
        }
    }
  }
}
