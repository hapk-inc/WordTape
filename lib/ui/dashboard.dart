import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../function/auth/pod.dart';
import 'common/store_btn.dart';
import 'dashboard/riddle_now.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
