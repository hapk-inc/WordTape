import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mock_data/mock_data.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../function/date/date.dart';
import '../function/riddle/notifier.dart';
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
  double height() => 420.r;
}

class Summary extends ConsumerStatefulWidget {
  final DateTime date;
  const Summary({required this.date, super.key});

  @override
  ConsumerState createState() => _SummaryState();
}

class _SummaryState extends ConsumerState<Summary> {
  bool show = false;

  @override
  void initState() {
    final RiddleNotifier notifier =
        ref.read(riddleNotifierProvider(widget.date));

    super.initState();
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        constraints: BoxConstraints(maxWidth: 300.r),
        color: seaWhite,
        child: Stack(
          children: [
            Lottie.asset(
              'lottie/confetti.json',
              repeat: false,
              onLoaded: (p0) => Future.delayed(
                p0.duration * 0.75,
                () => setState(() => show = true),
              ),
            ),
            if (show)
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
    final RiddleNotifier notifier = ref.read(riddleNotifierProvider(date));
    final bool noHelp = notifier.found.soFar.isEmpty;

    return LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          Expanded(
            child: Lottie.asset(
              'lottie/${noHelp ? 'trophy_1.json' : 'sad.json'}',
              fit: BoxFit.fitWidth,
              width: constraints.maxHeight * (noHelp ? 0.72 : 0.54),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: azureGreen,
            height: constraints.maxHeight * 0.24,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 15.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "congrats_detail_${mockInteger(0, 5)}".tr(),
                  style: GoogleFonts.montserrat(
                    color: midnightGreen,
                    fontWeight: FontWeight.w300,
                    fontSize: 15.r,
                    height: 0,
                    letterSpacing: 0,
                  ),
                  maxLines: 1,
                ),
                Gap(12.r),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "http://${mockString(60)}",
                        style: GoogleFonts.robotoMono(
                          fontSize: 15.r,
                          letterSpacing: 0,
                          height: 0,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Gap(7.5.r),
                    const Icon(Icons.copy)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
