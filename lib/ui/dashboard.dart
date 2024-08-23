import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:mock_data/mock_data.dart';
import 'package:animate_do/animate_do.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wordtape/logic/dot_env.dart';
import 'package:wordtape/logic/selected_date.dart';
import 'package:wordtape/router/app_router.gr.dart';
import 'package:wordtape/ui/puzzle.dart';

import '../logic/panel_controller.dart';
import '../logic/puzzle/key.dart';
import '../logic/puzzle/puzzle_panel.dart';
import '../logic/size.dart';

import '../logic/welcome_text.dart';
import 'theme/colors.dart';

@RoutePage()
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String size = ref.watch(sizeProvider);
    return LayoutBuilder(
      builder: (_, constraint) {
        final double maxHeight = constraint.maxHeight;
        final double maxWidth = constraint.maxWidth;
        return SafeArea(
          child: ColoredBox(
            color: seaWhite,
            child: ListView(
              children: [
                Gap(maxHeight * 0.015),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 750),
                  decoration: BoxDecoration(
                    color: midnightGreen,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  height: maxHeight * (size != "pc" ? 0.675 : 0.9),
                  margin: EdgeInsets.symmetric(horizontal: maxWidth * 0.015),
                  padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.015),
                  child: const PuzzleTile(),
                ),
                if (size != "pc") ...[
                  Gap(maxHeight * 0.015),
                  const MyCalendar(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.015),
                    child: Divider(
                      height: maxHeight * 0.06,
                      color: slateGray,
                      thickness: 0.45.r,
                    ),
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}

class PuzzleTile extends ConsumerWidget {
  const PuzzleTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String size = ref.watch(sizeProvider);
    final PanelController panelController = ref.read(panelControllerProvider);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (_, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double maxHeight = constraints.maxHeight;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(maxHeight * (size == "mobile" ? 0.075 : 0.15)),
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
                        },
                        child: const Text("Play Now"),
                      ),
                      SizedBox(width: maxWidth * 0.03),
                      OutlinedButton(
                        onPressed: () {},
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
                padding: EdgeInsets.symmetric(
                  horizontal: maxWidth * 0.045,
                ),
                alignment: Alignment.centerRight,
                child: Text(
                  "17 AUGUST 2024",
                  style: textTheme.displaySmall,
                ),
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
                style: textTheme.titleMedium?.copyWith(
                  color: aquaMarine,
                ),
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
    final int count = mockInteger(1, 30);
    final DotEnv env = ref.read(envProvider);
    final String foo = env.get('FOO');
    debugPrint(foo);
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
                textStyle: textTheme.displayLarge,
                duration: const Duration(milliseconds: 1200),
              ),
              Text(
                "Users Played today",
                style: textTheme.headlineMedium?.copyWith(
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MyCalendar extends ConsumerWidget {
  const MyCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final DateTime selectedDate = ref.watch(selectedDateProvider);
    //final DateTime now = DateTime.now();
    //final DateTime randomDate =
    //    mockDate(now.subtract(Duration(days: mockInteger(1, 3))), now);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 105.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 15.r),
        children: List.generate(
          9,
          (index) {
            final DateTime now = DateTime.now();
            final DateTime date = now.copyWith(day: now.day - index);
            final bool isSelected = date.day == selectedDate.day;
            final String week = DateFormat('EEE').format(date);
            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: EdgeInsets.symmetric(horizontal: 18.r),
              margin: EdgeInsets.symmetric(horizontal: 1.5.r),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? raisinBlack : null,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: InkWell(
                onTap: () {
                  ref.read(selectedDateProvider.notifier).state = date;
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      week.toUpperCase(),
                      style: textTheme.displaySmall?.copyWith(
                        color: isSelected ? seaWhite : slateGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Gap(3.r),
                    Text(
                      date.day.toString().padLeft(2, '0'),
                      style: textTheme.displayMedium?.copyWith(
                        color: isSelected ? seaWhite : slateGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
