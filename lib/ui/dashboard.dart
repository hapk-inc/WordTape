import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../function/package_info/pod.dart';
import '../function/puzzle/pod.dart';
import '../model/found.dart';
import '../model/puzzle.dart';
import '../model/welcome.dart';
import 'dashboard/leaderboard_tile.dart';
import 'dashboard/p_count.dart';
import 'dashboard/pass_btn.dart';
import 'dashboard/play_btn.dart';
import 'dashboard/see_archive.dart';
import 'dashboard/store_btn.dart';
import 'dashboard/two_word.dart';
import 'dashboard/welcome.dart';
import 'theme/color.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => LayoutBuilder(
        builder: (_, constraints) {
          final double mH = constraints.maxHeight;
          final double mW = constraints.maxWidth;
          final DateTime date = ref.read(selectedDateProvider);
          final Puzzle? puzzle =
              ref.watch(puzzleDateArgProvider(date: date)).maybeWhen(
                    orElse: () => null,
                    data: (d) => d,
                  );

          final Found? found =
              ref.watch(foundDateArgProvider(date: date)).value;

          if (found == null) return const CircularLoader();

          final Welcome w = ref.read(welcomeProvider);
          final Welcome r = ref.read(resumeProvider);
          final Welcome welcome = found.i == 1 ? w : r;
          final TextTheme textTheme = Theme.of(context).textTheme;

          final PackageInfo? packageInfo = ref.watch(packageProvider).value;

          //
          return SingleChildScrollView(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  color: midnightGreen,
                  constraints: BoxConstraints.expand(height: mH * 0.72),
                  padding: EdgeInsets.symmetric(horizontal: mW * 0.045),
                  child: SafeArea(
                    child: Stack(
                      children: [
                        const PCount(),
                        Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Gap(15),
                                WelcomeText(welcome),
                                const Gap(60),
                                if (puzzle != null)
                                  TwoWord(date, puzzle.correctWord(found)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const _MySpacer(fraction: 2),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.r),
                  child: OverflowBar(
                    alignment: MainAxisAlignment.center,
                    overflowAlignment: OverflowBarAlignment.center,
                    spacing: 15.r,
                    overflowSpacing: 15.r,
                    children: [
                      if (puzzle != null) const PlayBtn(),
                      const PassBtn(),
                    ],
                  ),
                ),
                const _MySpacer(fraction: 3),
                if (kIsWeb) ...[
                  SizedBox(
                    width: 450.r,
                    child: FadeIn(
                      delay: const Duration(milliseconds: 3600),
                      child: Lottie.asset(
                        'lottie/calendar.json',
                        repeat: false,
                      ),
                    ),
                  ),
                  const _MySpacer(),
                  const SeeArchive(),
                  const _MySpacer(fraction: 3),
                  const StoreBtn(),
                ] else ...[
                  const _MySpacer(),
                  const LeaderBoardTile(),
                  const _MySpacer(),
                ],
                const _MySpacer(fraction: 10),
                if (packageInfo != null)
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 15.r),
                    child: Text(
                      "Version ${packageInfo.version}",
                      style: textTheme.bodySmall?.copyWith(
                        height: 0,
                        fontSize: 18.r,
                        color: Colors.black26,
                      ),
                    ),
                  ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.r),
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    "WORDTAPE",
                    style: textTheme.displayLarge?.copyWith(
                      color: Colors.black12,
                      letterSpacing: 0,
                    ),
                    maxLines: 1,
                  ),
                ),
                const _MySpacer(fraction: 2),
              ],
            ),
          );
        },
      );
}

class CircularLoader extends StatelessWidget {
  const CircularLoader({super.key});

  @override
  Widget build(BuildContext context) => Container(
        color: midnightGreen,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(
          backgroundColor: seaWhite,
          color: aquaMarine,
        ),
      );
}

class _MySpacer extends StatelessWidget {
  final double fraction;
  const _MySpacer({this.fraction = 1});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Gap(height * 0.015 * fraction);
  }
}
