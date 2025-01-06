import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../extension/extension.dart';

import '../../function/question/notifier.dart';
import '../../function/underline_text/pod.dart';
import '../../model/custom_theme.dart';
import '../../model/underline_text.dart';
import '../../model/word.dart';
import '../../panel/pod.dart';
import '../../theme/color.dart';
import '../../theme/font.dart';
import '../../theme/pod.dart';
import '../common/editable_word.dart';
import '../common/gradient_box.dart';
import '../common/logo.dart';
import '../common/instruction.dart';

class RiddleNow extends ConsumerWidget {
  const RiddleNow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime date = DateTime.now().onlyYYYYMMMDD;
    final CustomTheme theme = ref.read(customThemeProvider(date.day));
    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: false,
      leadingWidth: 120.r,
      expandedHeight: 600.r,
      toolbarHeight: 90.h,
      titleSpacing: 0.r,
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1,
        title: BottomButton(date),
        background: GradientBox(color: theme.forToday, child: RiddleNowState()),
      ),
    );
  }
}

class BottomButton extends ConsumerWidget {
  final DateTime date;
  const BottomButton(this.date, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QuestionNotifier notifier = ref.watch(questionNotifierProvider(date));
    final CustomTheme customTheme = ref.read(customThemeProvider(date.day));
    return Padding(
      padding: EdgeInsets.only(bottom: 15.r),
      child: notifier.question == null
          ? null
          : OverflowBar(
              overflowAlignment: OverflowBarAlignment.center,
              spacing: 15.r,
              overflowSpacing: 15.r,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      customTheme.prevTile,
                    ),
                    foregroundColor: WidgetStatePropertyAll(raisinBlack),
                  ),
                  onPressed: () {
                    final DateTime now = DateTime.now();
                    final String date = DateFormat('dd-MMM-yyyy').format(now);
                    context.go('/daily-challenge/$date');
                  },
                  child: const Text("Play now"),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(panelNotifierProvider.notifier).state =
                        const InstructionDialog();
                  },
                  child: const Text("How to Play"),
                ),
              ],
            ),
    );
  }
}

class RiddleNowState extends ConsumerWidget {
  const RiddleNowState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => LayoutBuilder(
        builder: (_, constraints) {
          final double mW = constraints.maxWidth;
          final double mH = constraints.maxHeight;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 150),
                width: mW,
                bottom: mH * 0.15,
                top: mH * 0.09,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 150),
                  child: Theme(
                    data: ThemeData(
                      scrollbarTheme: ScrollbarThemeData(interactive: false),
                    ),
                    child: const RiddleNowStateState(),
                  ),
                ),
              ),
            ],
          );
        },
      );
}

class RiddleNowStateState extends ConsumerWidget {
  const RiddleNowStateState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime date = DateTime.now().onlyYYYYMMMDD;
    final UnderlineText underlineText = ref.read(dataLoadingProvider);
    final QuestionNotifier notifier = ref.watch(questionNotifierProvider(date));
    final List<Word> searchWord = notifier.searchWord;

    final CustomTheme customTheme = ref.read(customThemeProvider(date.day));

    List<String> words = underlineText.text.split(' ');
    List<String> highlighter = (underlineText.focused ?? "").split(' ');

    final DefaultTextTheme defaultTextTheme = DefaultTextTheme();

    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: notifier.question == null
            ? [
                FadeIn(
                  delay: const Duration(milliseconds: 2400),
                  child: AutoSizeText.rich(
                    TextSpan(
                      children: [
                        for (String word in words)
                          TextSpan(
                            text: word + (word != words.last ? " " : ""),
                            style: highlighter.contains(word)
                                ? defaultTextTheme.kanitMedium.copyWith(
                                    color: customTheme.pressColor,
                                    height: 1.8,
                                  )
                                : null,
                          ),
                      ],
                    ),
                    maxLines: 2,
                    style: defaultTextTheme.kanitMedium
                        .copyWith(color: azureGreen, height: 1.8),
                    presetFontSizes: [22.5.r, 21.r, 18.r],
                    textAlign: TextAlign.center,
                  ),
                ),
                FadeIn(
                  delay: const Duration(milliseconds: 1500),
                  child: SizedBox.square(
                    dimension: 450.r,
                    child: Lottie.asset(
                      'lottie/under_construction.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ]
            : [
                Gap(30.r),
                const Logo(),
                Gap(15.r),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.5.r),
                  child: const RiddleNowWelcome(),
                ),
                Gap(45.r),
                if (searchWord.isEmpty) ...[
                  QuestionUntilNow(date),
                ] else
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.5.r),
                    child: Column(
                      children: [
                        for (Word search in searchWord)
                          FadeIn(
                            delay: const Duration(milliseconds: 750),
                            child: EditableWord(
                              search,
                              inDailyChallenge: false,
                            ),
                          )
                      ],
                    ),
                  ),
              ],
      ),
    );
  }
}

class QuestionUntilNow extends ConsumerWidget {
  final DateTime date;
  const QuestionUntilNow(this.date, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QuestionNotifier notifier = ref.watch(questionNotifierProvider(date));
    final DefaultTextTheme defaultTextTheme = DefaultTextTheme();

    return AutoSizeText.rich(
      TextSpan(
        children: List.of(notifier.summary.map((e) => TextSpan(text: e))),
      ),
      style: defaultTextTheme.emojiMedium,
    );
  }
}

class RiddleNowWelcome extends ConsumerWidget {
  const RiddleNowWelcome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime date = DateTime.now().onlyYYYYMMMDD;
    final QuestionNotifier notifier = ref.watch(questionNotifierProvider(date));
    final DefaultTextTheme textTheme = DefaultTextTheme();
    final CustomTheme customTheme = ref.read(customThemeProvider(date.day));

    //
    final UnderlineText sentence = notifier.headline;

    List<String> words = sentence.text.split(' ');
    List<String> highlighter = (sentence.focused ?? "").split(' ');

    return FadeInUp(
      delay: const Duration(milliseconds: 1200),
      from: 45.h,
      key: ValueKey(sentence),
      child: AutoSizeText.rich(
        TextSpan(
          children: [
            for (String word in words)
              TextSpan(
                text: word + (word != words.last ? " " : ""),
                style: highlighter.contains(word)
                    ? textTheme.displaySmall?.copyWith(
                        color: customTheme.pressColor,
                        height: 1.8,
                      )
                    : null,
              ),
          ],
        ),
        maxLines: 2,
        style: textTheme.kanitMedium.copyWith(color: azureGreen, height: 1.8),
        presetFontSizes: [22.5.r, 21.r, 18.r],
        textAlign: TextAlign.center,
      ),
    );
  }
}
