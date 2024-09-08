import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../function/puzzle/notifier.dart';
import '../function/puzzle/pod.dart';
import '../model/puzzle.dart';
import '../model/word.dart';
import 'puzzle/custom_keyboard.dart';
import 'puzzle/hint.dart';
import 'puzzle/word_text_field.dart';
import 'theme/color.dart';

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
        top: false,
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxHeight = constraints.maxHeight;
            final double maxWidth = constraints.maxWidth;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(maxHeight * 0.03),
                  Container(
                    height: maxHeight * 0.06,
                    padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.03),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BackButton(color: seaWhite),
                        SizedBox.square(
                          dimension: maxHeight * 0.06,
                          child: Lottie.asset('lottie/bulb.json'),
                        )
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    height: maxHeight * 0.15,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.045),
                    child: const PuzzleHint(),
                  ),
                  ...List.generate(
                    puzzle.words.length,
                    (index) {
                      final Word word = puzzle.words[index];
                      return WordTextField(
                        index,
                        word,
                        height: maxHeight * 0.09,
                      );
                    },
                  ),
                  Gap(maxHeight * 0.018),
                  const CustomKeyboard(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
