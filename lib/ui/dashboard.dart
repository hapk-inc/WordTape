import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../function/auth/pod.dart';
import '../function/firestore/pod.dart';
import '../panel/pod.dart';
import '../shared/shared.dart';
import '../theme/color.dart';
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
        if (mounted) {
          final SharedPreferences pref =
              await ref.read(sharedPrefProvider.future);
          if (kIsWeb) {
            final bool acceptCookies = pref.getBool('accept_cookies') ?? false;
            if (acceptCookies) {
              ref.read(panelNotifierProvider.notifier).state =
                  const AcceptCookie();
            }
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: <Widget>[
          RiddleNow(),
          GameArchive(),
          SliverToBoxAdapter(child: PrevQuestion()),
          SliverToBoxAdapter(child: DashboardFooter()),
        ],
      );
}

/*class GoogleLogin extends ConsumerWidget {
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
}*/

class GameArchive extends ConsumerWidget {
  const GameArchive({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.fromLTRB(15.r, 30.r, 15.r, 15.r),
          child: Row(
            children: [
              Text(
                "Game Archives",
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(color: midnightGreen),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  final ScrollController controller =
                      ref.read(scrollControllerProvider);
                  if (controller.position.pixels > 0) {
                    controller.animateTo(
                      controller.offset - 450.r,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Icon(Icons.chevron_left, size: 36.r),
              ),
              InkWell(
                onTap: () {
                  final ScrollController controller =
                      ref.read(scrollControllerProvider);
                  if (controller.position.pixels <
                      controller.position.maxScrollExtent) {
                    controller.animateTo(
                      controller.offset + 450.r,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Icon(Icons.chevron_right, size: 36.r),
              ),
            ],
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
        ]
            .map(
              (e) => TextButton(
                onPressed: () {
                  if (e == "Privacy Policy") context.go("/privacy-policy");
                },
                child: Text(e),
              ),
            )
            .toList(),
      ),
    );
  }
}
