import 'package:animate_do/animate_do.dart';
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
import '../../enum/enum.dart';

import '../function/auth/pod.dart';

import '../function/date_selected/date_selected.dart';
import '../function/question/notifier.dart';
import '../panel/widget.dart';
import '../theme/color.dart';
import '../theme/font.dart';
import 'dashboard/riddle_now.dart';

class SummaryPage extends PanelWidget {
  final DateTime date;
  const SummaryPage({required this.date, super.key});

  @override
  Widget build(context, ref) => SizedBox(
        height: height(),
        width: 450.r,
        child: Summary(date: date),
      );

  @override
  SlideDirection direction() => SlideDirection.UP;

  @override
  double height() => 210.r;

  @override
  bool backdropEnabled() => false;
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
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        constraints: BoxConstraints(maxWidth: 300.r),
        color: seaWhite,
        child: Stack(
          children: [
            if (noHelp)
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
            if (show || !noHelp)
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
    final DateTime date = ref.read(dateSelectedProvider);
    final QuestionNotifier notifier = ref.read(questionNotifierProvider(date));
    final bool noHelp = notifier.found.untilNow.isEmpty;

    return LayoutBuilder(
      builder: (_, constraints) => Column(
        children: [
          Expanded(
            child: SafeArea(
              child: FadeIn(
                delay: const Duration(milliseconds: 750),
                child: Center(child: QuestionUntilNow(date)),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: azureGreen,
            height: 90.r,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 15.r),
            child: SummaryFooter(noHelp),
          )
        ],
      ),
    );
  }
}

class SummaryFooter extends ConsumerWidget {
  final bool noHelp;

  const SummaryFooter(this.noHelp, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PackageInfo? packageInfo = ref.read(packageProvider).value;
    final AppEnv appEnv = ref.read(appEnvProvider);
    final DefaultTextTheme defaultTextTheme = DefaultTextTheme();

    final String url =
        "https://${appEnv == AppEnv.dev ? "wordtape-demo" : "wordtape"}.web.app/";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          noHelp
              ? "congrats_detail_${mockInteger(0, 5)}".tr()
              : "pass_detail_${mockInteger(0, 6)}".tr(),
          style: defaultTextTheme.montserratMedium.copyWith(
            color: midnightGreen,
          ),
          maxLines: 1,
        ),
        Gap(7.5.r),
        if (packageInfo != null)
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
                InkWell(
                  onTap: () => Share.share(url),
                  child: const Icon(Icons.copy),
                ),
                Gap(7.5.r),
              ],
            ),
          )
      ],
    );
  }
}
