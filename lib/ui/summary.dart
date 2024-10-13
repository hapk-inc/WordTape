import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mock_data/mock_data.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wordtape/function/auth/pod.dart';
import '../../enum/enum.dart';

import '../function/date/date.dart';
import '../function/question/notifier.dart';
import '../model/word.dart';
import '../panel/widget.dart';
import '../theme/color.dart';

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
  SlideDirection direction() => SlideDirection.DOWN;

  @override
  double height() => 450.r;
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
                'lottie/confetti.json',
                repeat: false,
                onLoaded: (p0) => Future.delayed(
                  p0.duration * 0.75,
                  () => setState(() => show = true),
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
    final DateTime date = ref.read(selectedDateProvider);
    final QuestionNotifier notifier = ref.read(questionNotifierProvider(date));
    final bool noHelp = notifier.found.untilNow.isEmpty;

    return LayoutBuilder(
      builder: (_, constraints) => Column(
        children: [
          Expanded(
            child: noHelp
                ? Lottie.asset(
                    'lottie/trophy_1.json',
                    fit: BoxFit.fitWidth,
                    width: constraints.maxHeight * 0.75,
                  )
                : const SafeArea(child: Center(child: SummaryStatus())),
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

class SummaryStatus extends ConsumerWidget {
  const SummaryStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime date = ref.read(selectedDateProvider);
    final QuestionNotifier notifier = ref.read(questionNotifierProvider(date));
    final Map<int, dynamic> untilNow = notifier.found.untilNow;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        notifier.riddle?.words.length ?? 0,
        (index) {
          final Word word = notifier.riddle!.words[index];
          String str = word.value.split('').map(
            (e) {
              if (untilNow.isNotEmpty && untilNow.containsKey(index)) {
                List<String> list = List.castFrom(untilNow[index]);
                if (list.contains(e)) return "🟥";
              }
              return "🟩";
            },
          ).join();
          return Container(
            margin: EdgeInsets.only(bottom: 1.5.r),
            child: Text(
              str,
              style: GoogleFonts.notoColorEmoji(
                fontSize: 36.r,
                letterSpacing: 0.3.r,
                height: 0.r,
              ),
            ),
          );
        },
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          noHelp
              ? "congrats_detail_${mockInteger(0, 5)}".tr()
              : "pass_detail_${mockInteger(0, 9)}".tr(),
          style: GoogleFonts.montserrat(
            color: midnightGreen,
            fontSize: 15.r,
            height: 0,
            fontWeight: FontWeight.normal,
            letterSpacing: 0,
          ),
          maxLines: 1,
        ),
        Gap(7.5.r),
        if (packageInfo != null)
          Row(
            children: [
              Expanded(
                child: Text(
                  "https://${packageInfo.appName}.web.app/",
                  style: GoogleFonts.robotoMono(
                    fontSize: 15.r,
                    letterSpacing: 0,
                    wordSpacing: 0,
                    height: 0,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Gap(9.r),
              InkWell(
                onTap: () => Share.share(
                    "https://${appEnv == AppEnv.dev ? "wordtape-demo" : "wordtape"}.web.app/"),
                child: const Icon(Icons.copy),
              )
            ],
          )
      ],
    );
  }
}
