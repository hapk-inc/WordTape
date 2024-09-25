import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:mock_data/mock_data.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../model/date_ext.dart';
import '../model/underline_text.dart';
import '../model/word.dart';
import '../riddle/notifier.dart';
import '../theme/color.dart';
import 'common/editable_word.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final double mH = constraints.maxHeight;

        return CustomScrollView(
          slivers: <Widget>[
            TodayRiddle(),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 900.h,
                child: Center(
                  child: Text('Scroll to see the SliverAppBar in effect.'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class TodayRiddle extends ConsumerWidget {
  const TodayRiddle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: false,
      actions: [
        CircleAvatar(
          radius: 36.r,
          child: RandomAvatar(mockString()),
        ),
        Gap(7.5.r)
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(120.h),
        child: Padding(
          padding: EdgeInsets.only(bottom: 30.r),
          child: OverflowBar(
            spacing: 15.r,
            children: [
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(azureGreen),
                  foregroundColor: WidgetStatePropertyAll(raisinBlack),
                ),
                onPressed: () => context.push('/puzzle'),
                child: const Text("Play now"),
              ),
              ElevatedButton(onPressed: () {}, child: const Text("Play now")),
            ],
          ),
        ),
      ),
      expandedHeight: 600.r,
      toolbarHeight: 90.h,
      titleSpacing: 30.r,
      titleTextStyle: textTheme.displaySmall?.copyWith(
        color: azureGreen,
      ),
      title: const Text('WORDTAPE'),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        //collapseMode: CollapseMode.pin,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[midnightGreen, gunMetal],
            ),
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 7.5.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TodayRiddleTitle(),
              Gap(30.r),
              EditableWord(Word(value: mockName().toUpperCase())),
            ],
          ),
        ),
      ),
    );
  }
}

class TodayRiddleTitle extends ConsumerWidget {
  const TodayRiddleTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime now = DateTime.now().convert();
    final RiddleNotifier notifier = ref.read(riddleNotifierProvider(now));
    final TextTheme textTheme = Theme.of(context).textTheme;

    //
    final UnderlineText sentence = notifier.title;
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
            TextSpan(
              text: sentence.end,
              style: words.last == highlighter.last
                  ? textTheme.titleLarge?.copyWith(color: aquaMarine)
                  : null,
            )
          ],
        ),
        maxLines: 2,
        style: textTheme.bodyLarge?.copyWith(color: seaWhite),
        textAlign: TextAlign.center,
      ),
    );
  }
}
