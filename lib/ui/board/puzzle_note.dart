import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../logic/puzzle/bloc.dart';
import '../../logic/puzzle/found_notifier.dart';
import '../../model/found.dart';
import '../../model/puzzle.dart';
import '../../theme/colors.dart';

class PuzzleNote extends ConsumerWidget {
  const PuzzleNote({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Puzzle? puzzle = ref.read(puzzleProvider).valueOrNull;
    final Found? found = ref.watch(foundNotifierProvider).valueOrNull;

    if (puzzle == null && found == null) return Container();
    //
    if ((found?.i ?? 0) > 5) return Container();
    final String? note = puzzle?.words[found?.i ?? 0].note;
    if (note == null) return Container();
    //
    return FadeIn(
      delay: const Duration(milliseconds: 1500),
      child: Container(
        height: 60.h,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          "Note: $note",
          style: const TextStyle(color: slateGray),
        ),
      ),
    );
  }
}
