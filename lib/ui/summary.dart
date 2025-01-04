import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:mock_data/mock_data.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wordtape/router/path.dart';
import '../../enum/enum.dart';

import '../function/auth/pod.dart';

import '../function/question/notifier.dart';
import '../model/custom_theme.dart';
import '../panel/widget.dart';
import '../theme/color.dart';
import '../theme/font.dart';
import '../theme/pod.dart';
import 'dashboard/riddle_now.dart';

class SummaryPage extends PanelWidget {
  final DateTime date;
  const SummaryPage({required this.date, super.key});

  @override
  Widget build(context, ref) {
    final ScreenSize screenSize = ref.watch(sizeProvider);
    return SizedBox(
      height: screenSize != ScreenSize.mobile ? 270.r : height(),
      width: 480.r,
      child: Summary(date: date),
    );
  }

  @override
  SlideDirection direction() => SlideDirection.UP;

  @override
  double height() => 300.r;

  @override
  bool backdropEnabled() => true;
}

class Summary extends ConsumerStatefulWidget {
  final DateTime date;
  const Summary({required this.date, super.key});

  @override
  ConsumerState createState() => _SummaryState();
}

class _SummaryState extends ConsumerState<Summary> {
  bool show = false;
  late bool noHelp;

  @override
  void initState() {
    final QuestionNotifier notifier =
        ref.read(questionNotifierProvider(widget.date));
    noHelp = notifier.found.untilNow.isEmpty;

    super.initState();
  }

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: ghostWhite,
        child: Stack(
          children: [
            Lottie.asset(
              'confetti'.tr(),
              repeat: false,
              onLoaded: (p0) => Future.delayed(
                p0.duration * 0.75,
                () {
                  if (mounted) setState(() => show = true);
                },
              ),
            ),
            FadeIn(
              duration: const Duration(milliseconds: 750),
              child: const Center(child: SummaryContent()),
            ),
          ],
        ),
      );
}

class SummaryContent extends ConsumerWidget {
  const SummaryContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime date = ref.read(pathNotifierProvider).date;
    final DefaultTextTheme textTheme = DefaultTextTheme();
    final CustomTheme customTheme = ref.read(customThemeProvider(date.day));
    return LayoutBuilder(
      builder: (_, constraints) => Column(
        children: [
          Expanded(
            child: FadeIn(
              delay: const Duration(milliseconds: 600),
              child: Stack(
                children: [
                  Positioned(
                    left: 15.r,
                    top: 7.5.r,
                    child: AutoSizeText.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "🟩",
                            style:
                                textTheme.emojiSmall.copyWith(fontSize: 12.r),
                          ),
                          TextSpan(text: "  Found a word on your own\n"),
                          TextSpan(
                            text: "🟧",
                            style:
                                textTheme.emojiSmall.copyWith(fontSize: 12.r),
                          ),
                          TextSpan(text: "  Used hint"),
                        ],
                      ),
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 12.r,
                        color: cadetGray,
                      ),
                      presetFontSizes: [12.r, 9.r],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 30.r),
                    child: QuestionUntilNow(date),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: customTheme.prevTile,
            height: 135.r,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 15.r),
            child: SummaryFooter(date),
          )
        ],
      ),
    );
  }
}

class SummaryFooter extends ConsumerWidget {
  final DateTime date;
  const SummaryFooter(this.date, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QuestionNotifier questionNotifier =
        ref.watch(questionNotifierProvider(date));
    final PackageInfo? packageInfo = ref.read(packageProvider).value;
    final AppEnv appEnv = ref.read(appEnvProvider);
    final DefaultTextTheme defaultTextTheme = DefaultTextTheme();
    final CustomTheme customTheme = ref.read(customThemeProvider(date.day));

    final String dateStr = DateFormat('MMM dd').format(date);

    final String url =
        "https://${appEnv == AppEnv.dev ? "wordtape-demo" : "wordtape-51"}"
        ".web.app/";

    final String str =
        "$url\n\n${dateStr.toUpperCase()}: ${questionNotifier.summary.join()}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "pass_detail_${mockInteger(0, 6)}".tr(),
          style: defaultTextTheme.kanitMedium
              .copyWith(color: customTheme.forToday[0]),
          maxLines: 1,
        ),
        Gap(1.5.r),
        if (packageInfo != null) ...[
          SafeArea(
            bottom: false,
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    url,
                    style: defaultTextTheme.urlTheme,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Gap(7.5.r),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  customTheme.forToday[1],
                ),
              ),
              onPressed: () => Share.share(str),
              child: Text("Share"),
            ),
          ),
        ]
      ],
    );
  }
}
