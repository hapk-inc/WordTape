import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../function/auth/pod.dart';
import '../panel/pod.dart';
import '../shared/shared.dart';
import 'common/accept_cookies.dart';
import 'common/store_btn.dart';
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
        final SharedPreferences pref = await ref.read(sharedProvider.future);
        if (kDebugMode || kIsWeb) {
          final bool acceptCookies = pref.getBool('accept_cookies') ?? false;
          if (!acceptCookies || kDebugMode) {
            ref.read(panelNotifierProvider.notifier).dialogState =
                const AcceptCookie();
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: <Widget>[
        RiddleNow(),
        SliverToBoxAdapter(child: Gap(15)),
        if (kIsWeb) SliverToBoxAdapter(child: StoreBtn()),
        SliverToBoxAdapter(child: Gap(1.5)),
        SliverToBoxAdapter(child: DashboardFooter())
      ],
    );
  }
}

class DashboardFooter extends ConsumerWidget {
  const DashboardFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PackageInfo? packageInfo = ref.watch(packageProvider).value;
    return OverflowBar(
      spacing: 7.5.r,
      alignment: MainAxisAlignment.center,
      children: [
        if (packageInfo != null)
          "Version ${packageInfo.version}(${packageInfo.buildNumber})",
        "Privacy Policy",
      ].map((e) => TextButton(onPressed: () {}, child: Text(e))).toList(),
    );
  }
}
