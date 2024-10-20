import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:wordtape/function/underline_text/pod.dart';

import '../../function/date/date.dart';
import '../../function/firestore/pod.dart';
import '../../function/question/notifier.dart';
import '../../model/player.dart';
import '../../model/underline_text.dart';
import '../../model/word.dart';
import '../../panel/pod.dart';
import '../../theme/color.dart';
import '../../theme/font.dart';
import '../common/editable_word.dart';
import '../common/gradient_box.dart';
import '../common/logo.dart';
import '../common/logoff.dart';
import '../common/notify.dart';

class RiddleNow extends ConsumerWidget {
  const RiddleNow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final TextTheme textTheme = Theme.of(context).textTheme;
    // final String share = "ref.read(passPromptProvider)";
    final DateTime date = ref.read(nowProvider);
    final QuestionNotifier notifier = ref.watch(questionNotifierProvider(date));

    //
    // final PackageInfo? package = ref.read(packageProvider).value;
    // final String name = (package?.appName ?? "").toUpperCase();
    //
    final Player? player = ref.watch(playerProvider).value;

    final UnderlineText underlineText = ref.read(notifyTextProvider);

    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: false,
      actions: [
        if (player != null)
          if (player.source != "web")
            CircleAvatar(
              radius: 36.r,
              backgroundColor: aquaMarine,
              child: InkWell(
                onTap: () => ref.read(panelNotifierProvider.notifier).state =
                    const LogoffAlert(),
                child: RandomAvatar(
                  player.avatar ?? "${player.rollNo}",
                  trBackground: true,
                ),
              ),
            ),
        Gap(15.r)
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(120.h),
        child: Padding(
          padding: EdgeInsets.only(bottom: 30.r),
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
                    final DateTime date = ref.read(selectedDateProvider);
                    context.push('/riddle', extra: date);
                  },
                  child: const Text("Play now"),
                ),
              ElevatedButton(
                onPressed: () => ref
                    .read(panelNotifierProvider.notifier)
                    .state = const NotifyDialog(),
                child: Text(underlineText.text),
              ),
            ],
          ),
        ),
      ),
      expandedHeight: 720.r,
      toolbarHeight: 90.h,
      titleSpacing: 30.r,
      // titleTextStyle: textTheme.displayMedium?.copyWith(color: seaWhite),
      // title: Text(name),
      flexibleSpace: const FlexibleSpaceBar(
        background: GradientBox(child: RiddleNowState()),
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
                bottom: 0,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 150),
                  child: SizedBox(
                    height: mH * 0.85,
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
    final DateTime date = ref.read(nowProvider);
    final QuestionNotifier notifier = ref.watch(questionNotifierProvider(date));
    final List<Word> searchWord = notifier.searchWord;

    return Column(
      children: [
        Gap(30.r),
        const Logo(),
        Gap(30.r),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.6.r),
          child: const RiddleNowWelcome(),
        ),
        Gap(30.r),
        if (searchWord.isEmpty) ...[
          QuestionUntilNow(date),
          Gap(60.r),
          if (notifier.done)
            FadeIn(
              delay: const Duration(milliseconds: 3600),
              child: const FeedbackTextField(),
            ),
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
      ],
    );
  }
}

class FeedbackTextField extends ConsumerWidget {
  const FeedbackTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.r),
      child: TextFormField(
        keyboardType: TextInputType.text,
        textAlignVertical: TextAlignVertical.bottom, //
        cursorHeight: 36.r,
        style: textTheme.bodyLarge?.copyWith(color: seaWhite),
        decoration: const InputDecoration(
          hintText: 'Enter your feedback here',
        ),
        maxLines: 1,
        maxLength: 90,
        textInputAction: TextInputAction.done,
        validator: (String? text) {
          if (text == null || text.isEmpty) {
            return 'Please enter your feedback';
          }
          return null;
        },
      ),
    );
  }
}

class QuestionUntilNow extends ConsumerWidget {
  final DateTime date;
  const QuestionUntilNow(this.date, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QuestionNotifier notifier = ref.read(questionNotifierProvider(date));
    final Map<int, dynamic> untilNow = notifier.found.untilNow;
    final DefaultTextTheme defaultTextTheme = DefaultTextTheme();

    final String foundEmoji = List.generate(
      notifier.question?.words.length ?? 0,
      (index) {
        if (untilNow.containsKey(index)) return "🟥";
        return "🟩";
      },
    ).join();
    return Text(foundEmoji, style: defaultTextTheme.emojiTheme);
  }
}

class RiddleNowWelcome extends ConsumerWidget {
  const RiddleNowWelcome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime date = ref.read(nowProvider);
    final QuestionNotifier notifier = ref.watch(questionNotifierProvider(date));
    final TextTheme textTheme = Theme.of(context).textTheme;

    //
    final UnderlineText sentence = notifier.header;
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
        textAlign: TextAlign.center,
      ),
    );
  }
}
