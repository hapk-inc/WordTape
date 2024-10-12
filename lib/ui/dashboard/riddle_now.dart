import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:wordtape/function/question/notifier.dart';

import '../../function/auth/pod.dart';
import '../../function/date/date.dart';
import '../../function/firestore/pod.dart';
import '../../function/underline_text/pod.dart';
import '../../model/player.dart';
import '../../model/underline_text.dart';
import '../../model/word.dart';
import '../../panel/pod.dart';
import '../../theme/color.dart';
import '../common/editable_word.dart';
import '../common/gradient_box.dart';
import '../common/logoff.dart';
import '../common/notify.dart';

class RiddleNow extends ConsumerWidget {
  const RiddleNow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String share = ref.read(passPromptProvider);
    final DateTime date = ref.read(nowProvider);
    final QuestionNotifier notifier = ref.watch(questionNotifierProvider(date));

    //
    final PackageInfo? package = ref.read(packageProvider).value;
    final String name = (package?.appName ?? "").toUpperCase();
    //
    final Player? player = ref.watch(playerProvider).value;
    log(player.toString());
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
            spacing: 15.r,
            children: [
              if (notifier.riddle != null)
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
                    .state = const NotifyAndShare(),
                child: Text(share),
              ),
            ],
          ),
        ),
      ),
      expandedHeight: 600.r,
      toolbarHeight: 90.h,
      titleSpacing: 30.r,
      titleTextStyle: textTheme.displayMedium?.copyWith(color: seaWhite),
      title: Text(name),
      flexibleSpace: const FlexibleSpaceBar(
        background: GradientBox(child: RiddleNowState()),
      ),
    );
  }
}

class RiddleNowState extends ConsumerWidget {
  const RiddleNowState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime date = ref.read(nowProvider);
    final QuestionNotifier notifier = ref.watch(questionNotifierProvider(date));
    final List<Word> search = notifier.searchWord;
    return LayoutBuilder(
      builder: (_, constraints) {
        final double mW = constraints.maxWidth;
        final double mH = constraints.maxHeight;
        return Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 150),
              width: mW,
              bottom: mH * 0.18,
              child: SizedBox(
                height: mH * 0.6,
                child: Column(
                  children: [
                    Gap(30.r),
                    Container(
                      width: 600.r,
                      padding: EdgeInsets.symmetric(horizontal: 7.5.r),
                      child: const RiddleNowWelcome(),
                    ),
                    Gap(30.r),
                    for (Word search in search)
                      FadeIn(
                        delay: const Duration(milliseconds: 750),
                        child: EditableWord(search),
                      ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
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
    List<String> highlighter = (sentence.focus ?? "").split(' ');
    return FadeInUp(
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
