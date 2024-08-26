import 'package:animate_do/animate_do.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../logic/puzzle/puzzle_notifier.dart';
import '../../logic/selected_date.dart';
import '../../logic/size.dart';
import '../../logic/welcome_text.dart';
import '../../model/puzzle.dart';
import '../theme/colors.dart';
import 'play_button.dart';

class PuzzleTile extends ConsumerWidget {
  final DateTime date;
  const PuzzleTile(this.date, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String size = ref.watch(sizeProvider);
    final Puzzle? puzzle = ref.watch(selectedPuzzleProvider(date)).value;
    String formattedDate = DateFormat('d MMMM, y').format(date).toUpperCase();
    final TextTheme textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (_, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double maxHeight = constraints.maxHeight;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(maxHeight * (size == "mobile" ? 0.075 : 0.105)),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.03),
                child: FadeIn(
                  delay: const Duration(milliseconds: 750),
                  child: Welcome(puzzle),
                ),
              ),
              Gap(maxHeight * 0.075),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: maxWidth * 0.03),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PlayButton(puzzle),
                      SizedBox(width: maxWidth * 0.03),
                      OutlinedButton(
                        /*onPressed: () => ref
                            .read(selectedDateNotifierProvider)
                            .deleteDatabase(),*/
                        onPressed: () => ref.read(deleteDatabaseProvider),
                        style: const ButtonStyle(
                          foregroundColor: WidgetStatePropertyAll(seaWhite),
                          side: WidgetStatePropertyAll(
                            BorderSide(color: slateGray),
                          ),
                        ),
                        child: const Text("Share puzzle"),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(maxHeight * 0.075),
              FadeIn(
                delay: const Duration(milliseconds: 1500),
                child: const TodayCount(),
              ),
              Gap(maxHeight * 0.075),
              Container(
                padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.045),
                alignment: Alignment.centerRight,
                child: Text(formattedDate, style: textTheme.displaySmall),
              )
            ],
          ),
        );
      },
    );
  }
}

class Welcome extends ConsumerWidget {
  final Puzzle? puzzle;
  const Welcome(this.puzzle, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String size = ref.watch(sizeProvider);
    final WelcomeText welcomeText = ref.read(welcomeTextProvider);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            children: [
              if (puzzle != null) ...[
                TextSpan(text: welcomeText.text),
                if (size != "mobile") TextSpan(text: welcomeText.sub),
              ] else ...[
                const TextSpan(text: "No ")
              ],
              TextSpan(
                text: "puzzle.",
                style: textTheme.titleMedium?.copyWith(color: aquaMarine),
              )
            ],
          )
        ],
      ),
      style: textTheme.labelMedium?.copyWith(color: seaWhite),
    );
  }
}

class TodayCount extends ConsumerWidget {
  const TodayCount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    //final int count = ref.watch(selectedDateNotifierProvider).puzzle.played;

    return LayoutBuilder(
      builder: (_, constraint) {
        final double maxWidth = constraint.maxWidth;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.045),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedFlipCounter(
                value: 0,
                wholeDigits: 2,
                padding: EdgeInsets.zero,
                textStyle: textTheme.displayLarge?.copyWith(letterSpacing: 0.3),
                duration: const Duration(milliseconds: 1200),
              ),
              Text(
                0 == 0
                    ? "Be the First Player to start"
                    : "Users Played so far...",
                //mockString(),
                style: textTheme.headlineSmall?.copyWith(color: Colors.white54),
              ),
            ],
          ),
        );
      },
    );
  }
}
