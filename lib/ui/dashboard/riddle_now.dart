import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../extension/extension.dart';

import '../../function/date_selected/date_selected.dart';
import '../../function/question/notifier.dart';
import '../../model/underline_text.dart';
import '../../model/word.dart';
import '../../panel/pod.dart';
import '../../theme/color.dart';
import '../../theme/font.dart';
import '../common/editable_word.dart';
import '../common/gradient_box.dart';
import '../common/logo.dart';
import '../common/instruction.dart';

class RiddleNow extends ConsumerWidget {
  const RiddleNow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime date = DateTime.now().convert();

    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: true,
      leadingWidth: 120.r,
      expandedHeight: 675.r,
      toolbarHeight: 90.h,
      titleSpacing: 0.r,
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1,
        title: BottomButton(date),
        background: const GradientBox(child: RiddleNowState()),
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
    return Padding(
      padding: EdgeInsets.only(bottom: 15.r),
      child: OverflowBar(
        overflowAlignment: OverflowBarAlignment.center,
        spacing: 15.r,
        overflowSpacing: 15.r,
        children: [
          if (notifier.question != null)
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(azureGreen),
                foregroundColor: WidgetStatePropertyAll(raisinBlack),
              ),
              onPressed: () {
                final DateTime now = DateTime.now().convert();
                ref.read(dateSelectedProvider.notifier).state = now;
                context.push('/decode', extra: now);
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
                  child: const RiddleNowStateState(),
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
    final DateTime date = DateTime.now().convert();
    final QuestionNotifier notifier = ref.watch(questionNotifierProvider(date));
    final List<Word> searchWord = notifier.searchWord;

    return Column(
      children: [
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
                    child: EditableWord(search),
                  )
              ],
            ),
          ),
        /*Spacer(),
        if (notifier.question != null)
          FadeInUp(
            delay: const Duration(seconds: 3),
            from: 30.h,
            key: ValueKey(played),
            child: Text(
              played != 0
                  ? "$played users have joined in on today's challenge."
                  : "Be the first player to finish today's challenge!",
              style: textTheme.bodySmall?.copyWith(color: celeste),
            ),
          )*/
      ],
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
    final DateTime date = DateTime.now().convert();
    final QuestionNotifier notifier = ref.watch(questionNotifierProvider(date));
    final TextTheme textTheme = Theme.of(context).textTheme;

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
                    ? textTheme.titleLarge?.copyWith(color: aquaMarine)
                    : null,
              ),
          ],
        ),
        maxLines: 2,
        style: textTheme.bodyLarge?.copyWith(color: azureGreen),
        presetFontSizes: [22.5.r, 21.r, 18.r],
        textAlign: TextAlign.center,
      ),
    );
  }
}
