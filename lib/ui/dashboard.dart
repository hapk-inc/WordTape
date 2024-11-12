import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../function/auth/pod.dart';
import '../panel/pod.dart';
import '../router/router.dart';
import '../shared/shared.dart';
import '../theme/color.dart';
import '../theme/font.dart';
import 'common/accept_cookies.dart';
import 'dashboard/prev_question.dart';
import 'dashboard/riddle_now.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 1500),
      () async {
        final PanelNotifier notifier = ref.read(panelNotifierProvider.notifier);
        final String location =
            ref.read(routerProvider).routeInformationProvider.value.uri.path;
        if (location == "/home") {
          final SharedPreferences pref = await ref.read(sharedProvider.future);
          if (kIsWeb) {
            final bool acceptCookies = pref.getBool('accept_cookies') ?? false;
            if (!acceptCookies) notifier.state = const AcceptCookie();
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = ref.watch(runningUserProvider).value;
    final bool isAnonymous = user?.isAnonymous ?? true;
    return CustomScrollView(
      slivers: <Widget>[
        RiddleNow(),
        if (isAnonymous) ...[
          GoogleLogin(),
        ] else ...[
          GameArchives(),
          SliverToBoxAdapter(child: PrevQuestion()),
        ],
        SliverToBoxAdapter(child: DashboardFooter()),
      ],
    );
  }
}

class GoogleLogin extends ConsumerWidget {
  const GoogleLogin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DefaultTextTheme textTheme = DefaultTextTheme();
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(15.r),
        child: Column(
          children: [
            Text(
              "Would you like to revisit the previous games?",
              style: textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            Gap(15.r),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: WidgetStatePropertyAll(Size(300.r, 60.r)),
                backgroundColor: WidgetStatePropertyAll(gunMetal),
              ),
              onPressed: () => ref.read(googleAuthProvider.future).onError(
                (error, stackTrace) {
                  scaffoldKey.currentState?.showSnackBar(SnackBar(
                    content: Text("Authentication Failed $error"),
                  ));
                  return null;
                },
              ),
              child: Text(
                "CREATE A FREE ACCOUNT",
                style: textTheme.headlineMedium?.copyWith(color: azureGreen),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameArchives extends StatelessWidget {
  const GameArchives({super.key});

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.all(15.r),
          child: Text(
            "Game Archives",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
      );
}

class DashboardFooter extends ConsumerWidget {
  const DashboardFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PackageInfo? packageInfo = ref.watch(packageProvider).value;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30.r),
      child: OverflowBar(
        spacing: 7.5.r,
        alignment: MainAxisAlignment.center,
        children: [
          if (packageInfo != null)
            "Version ${packageInfo.version}(${packageInfo.buildNumber})",
          "Privacy Policy",
        ].map((e) => TextButton(onPressed: () {}, child: Text(e))).toList(),
      ),
    );
  }
}
