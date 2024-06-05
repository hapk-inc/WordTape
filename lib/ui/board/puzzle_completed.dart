import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../logic/puzzle/found_notifier.dart';
import '../../model/found.dart';
import '../../theme/colors.dart';

const Duration m750 = Duration(milliseconds: 750);

class PuzzleCompleted extends ConsumerWidget {
  const PuzzleCompleted({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Found? found = ref.watch(foundNotifierProvider).value;

    if (found == null) return Container();

    final DateTime now = DateTime.now();
    final DateTime lastFound = found.lastFound ?? now;

    final String str = now.day == lastFound.day
        ? "Today ${DateFormat('h : mm a').format(lastFound)}"
        : DateFormat('MMMM d, y h: mm a').format(lastFound);

    final TextTheme textTheme = Theme.of(context).textTheme;

    return FadeIn(
      delay: const Duration(milliseconds: 1200),
      child: Container(
        height: 180.h,
        margin: EdgeInsets.symmetric(horizontal: 15.r),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: teal,
          borderRadius: BorderRadius.circular(7.5.r),
        ),
        child: LayoutBuilder(
          builder: (_, constraint) => Padding(
            padding:
                EdgeInsets.symmetric(horizontal: constraint.maxWidth * 0.036),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  height: constraint.maxHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StarLottie(),
                      Text(
                        "Congratulations",
                        style: textTheme.titleMedium?.copyWith(height: 2.1),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  top: constraint.maxHeight * 0.12,
                  child: Text(
                    str,
                    style: textTheme.labelSmall?.copyWith(color: elbow),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StarLottie extends StatefulWidget {
  const StarLottie({super.key});

  @override
  State<StarLottie> createState() => _StarLottieState();
}

class _StarLottieState extends State<StarLottie> {
  bool repeat = true;
  @override
  Widget build(BuildContext context) => Container(
        constraints: BoxConstraints.tight(Size.square(75.r)),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Lottie.asset(
            'lottie/trophy.json',
            errorBuilder: (_, __, ___) => const Text("🏆"),
            repeat: repeat,
            onLoaded: (composition) {
              Future.delayed(
                composition.duration * 6,
                () => mounted ? setState(() => repeat = false) : null,
              );
            },
          ),
        ),
      );
}

/*
class PuzzleCompleted extends ConsumerWidget {
  final Found found;
  const PuzzleCompleted(this.found, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Puzzle? puzzle = ref.read(puzzleProvider).value;
    final DateTime now = DateTime.now();
    final DateTime lastFound = found.lastFound ?? DateTime.now();
    final String str = now.day == lastFound.day
        ? "Today at ${DateFormat('h:mm a').format(lastFound)}"
        : DateFormat('MMMM d, y h:mm a').format(lastFound);
    return FadeIn(
      delay: m750,
      child: Container(
        height: 120.r,
        color: seaSalt,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 15.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Completed",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: teal),
                ),
                OutlinedButton.icon(
                  icon: Icon(Icons.share, size: 21.r, color: ashGray),
                  onPressed: () => Clipboard.setData(
                    ClipboardData(text: puzzle?.shareCode ?? ""),
                  ).then(
                    (value) {},
                  ),
                  label: const Text(
                    "SHARE TODAY'S GAME",
                    style: TextStyle(color: teal),
                  ),
                )
              ],
            ),
            Gap(7.5.r),
            Text(str, style: const TextStyle(color: ashGray)),
          ],
        ),
      ),
    );
  }
}
*/
