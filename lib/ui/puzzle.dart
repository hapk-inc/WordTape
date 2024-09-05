import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:wordtape/function/puzzle/pod.dart';

import '../function/puzzle/notifier.dart';
import '../model/puzzle.dart';
import '../model/word.dart';
import 'puzzle/custom_keyboard.dart';
import 'puzzle/hint.dart';
import 'puzzle/word_text_field.dart';
import 'theme/colors.dart';

class PuzzlePage extends ConsumerStatefulWidget {
  final DateTime date;
  const PuzzlePage(this.date, {super.key});

  @override
  ConsumerState<PuzzlePage> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends ConsumerState<PuzzlePage> {
  late DateTime date;

  @override
  void initState() {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateStr = formatter.format(widget.date);
    date = formatter.parse(dateStr);
    Future.delayed(
      const Duration(milliseconds: 600),
      () => ref.read(selectedDateProvider.notifier).state = date,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PuzzleNotifier notifier = ref.watch(puzzleNotifierProvider(date));
    final Puzzle puzzle = notifier.puzzle;

    ref.listen(
      puzzleNotifierProvider(date).select((value) => value.found.i),
      (previous, next) {
        ref.read(puzzleNotifierProvider(date)).validateController();
      },
    );

    return ColoredBox(
      color: midnightGreen,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxHeight = constraints.maxHeight;
            final double maxWidth = constraints.maxWidth;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 15.r),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      height: maxHeight * 0.21,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: maxWidth * 0.03),
                      child: const PuzzleHint(),
                    ),
                    for (Word word in puzzle.words)
                      WordTextField(
                        word,
                        height: maxHeight * 0.09,
                      ),
                    Gap(maxHeight * 0.045),
                    const CustomKeyboard(),
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
