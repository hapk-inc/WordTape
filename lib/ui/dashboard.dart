import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import '../function/puzzle/pod.dart';
import '../model/found.dart';
import '../model/puzzle.dart';
import '../model/welcome.dart';
import 'dashboard/p_count.dart';
import 'dashboard/pass_btn.dart';
import 'dashboard/play_btn.dart';
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
          final DateTime date = ref.watch(selectedDateProvider);
          final Puzzle? puzzle =
              ref.watch(puzzleDateArgProvider(date: date)).when(
                    loading: () => null,
                    error: (error, stackTrace) {
                      debugPrintStack(stackTrace: stackTrace);
                      return null;
                    },
                    data: (data) => data,
                  );

          //
          //if (puzzle == null) return Container(color: midnightGreen);

          //
          final Found? found =
              ref.watch(foundDateArgProvider(date: date)).value;
          if (found == null) return Container(color: midnightGreen);

          //
          final Welcome welcome = found.i == 1
              ? ref.read(welcomeProvider)
              : ref.read(resumeProvider);
          return ListView(
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Gap(15),
                            WelcomeText(welcome),
                            const Gap(60),
                            if (puzzle != null)
                              TwoWord(date, puzzle.guess(found)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(mH * 0.03),
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
              Gap(mH * 0.045),
              SizedBox(
                width: 450.r,
                child: FadeIn(
                  delay: const Duration(milliseconds: 3600),
                  child: Lottie.asset('lottie/calendar.json', repeat: false),
                ),
              ),
              if (!kIsWeb) ...[
                Gap(mH * 0.015),
                const SeeArchive(),
                Gap(mH * 0.045),
                const StoreBtn(),
              ],
              Gap(mH * 0.3),
            ],
          );
        },
      );
}

class StoreBtn extends StatelessWidget {
  const StoreBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 30.r,
      runSpacing: 15.r,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        SizedBox(
          width: 210.r,
          child: Lottie.asset('lottie/app_store.json', fit: BoxFit.fitWidth),
        ),
        SizedBox(
          width: 210.r,
          child: Image.asset('images/play-store.png', fit: BoxFit.fitWidth),
        ),
      ],
    );
  }
}

class SeeArchive extends ConsumerWidget {
  const SeeArchive({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Welcome sentence = ref.read(archiveTextProvider);
    List<String> words = sentence.text.split(' ');
    List<String> highlighter = (sentence.highlight ?? "").split(' ');
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.r),
      child: FadeInUp(
        delay: const Duration(milliseconds: 600),
        from: 45.h,
        key: ValueKey(sentence),
        child: AutoSizeText.rich(
          TextSpan(
            children: [
              for (String word in words)
                TextSpan(
                  text: word + (word != words.last ? " " : ""),
                  style: highlighter.contains(word)
                      ? textTheme.titleLarge?.copyWith(color: slateGray)
                      : null,
                ),
            ],
          ),
          maxLines: 2,
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
            height: 1.8,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
