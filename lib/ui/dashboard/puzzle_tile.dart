import 'package:animate_do/animate_do.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../logic/panel_controller.dart';
import '../../logic/puzzle/key.dart';
import '../../logic/puzzle/puzzle_panel.dart';
import '../../logic/selected_date.dart';
import '../../logic/size.dart';
import '../../logic/welcome_text.dart';
import '../../model/puzzle.dart';
import '../../router/my_router.dart';
import '../puzzle.dart';
import '../theme/colors.dart';

class PuzzleTile extends ConsumerWidget {
  const PuzzleTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String size = ref.watch(sizeProvider);
    final PanelController panelController = ref.read(panelControllerProvider);
    final Puzzle puzzle = ref.watch(selectedDateNotifierProvider).puzzle;
    String formattedDate =
        DateFormat('d MMMM, y').format(puzzle.date).toUpperCase();
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
                  child: const Welcome(),
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
                      ElevatedButton(
                        onPressed: () {
                          const String id = "xyx";
                          if (kIsWeb) {
                            context.router.push(PuzzleRoute(id: id));
                          } else {
                            if (panelController.isAttached) {
                              if (panelController.isPanelClosed) {
                                ref.read(puzzleKeyProvider.notifier).state = id;
                                ref.read(puzzlePanelProvider.notifier).state =
                                    const PuzzlePage(id: id);
                                panelController.open();
                              }
                            } else {
                              context.router.push(PuzzleRoute(id: id));
                            }
                          }
                        },
                        child: const Text("Play Now"),
                      ),
                      SizedBox(width: maxWidth * 0.03),
                      OutlinedButton(
                        onPressed: () => ref
                            .read(selectedDateNotifierProvider)
                            .deleteDatabase(),
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
  const Welcome({super.key});

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
              TextSpan(text: welcomeText.text),
              if (size != "mobile") TextSpan(text: welcomeText.sub),
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
    final int count = ref.watch(selectedDateNotifierProvider).puzzle.played;

    return LayoutBuilder(
      builder: (_, constraint) {
        final double maxWidth = constraint.maxWidth;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.045),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedFlipCounter(
                value: count,
                wholeDigits: 2,
                padding: EdgeInsets.zero,
                textStyle: textTheme.displayLarge?.copyWith(letterSpacing: 0.3),
                duration: const Duration(milliseconds: 1200),
              ),
              Text(
                count == 0
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
