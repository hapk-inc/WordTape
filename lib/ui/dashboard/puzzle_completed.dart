import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../logic/puzzle/bloc.dart';
import '../../model/found.dart';
import '../../model/puzzle.dart';
import '../../theme/colors.dart';

const Duration m750 = Duration(milliseconds: 750);

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
