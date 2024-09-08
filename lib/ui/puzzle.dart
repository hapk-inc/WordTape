import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    ref.listen<int>(
      puzzleNotifierProvider(date).select<int>((value) => value.found.i),
      (previous, next) {
        log("Listen Found $next");
        ref.read(puzzleNotifierProvider(date)).validateController();
      },
    );

    return ColoredBox(
      color: midnightGreen,
      child: SafeArea(
        top: false,
        bottom: false,
        child: KeyboardListener(
          focusNode: notifier.activeNode,
          autofocus: true,
          onKeyEvent: (value) {
            log("onKeyEvent");
            ref.read(keyNotifierProvider.notifier).state = value.logicalKey;
            /*log("30==$value");

            final String str = value.character ?? "";
            final PuzzleNotifier notifierRead =
                ref.read(puzzleNotifierProvider(date));
            if (str.isNotEmpty && str.length == 1) {
              log("STR=$str==");
              notifierRead.addText(str.toUpperCase());
            } else {
              log("${value.physicalKey.debugName}==");
              switch (value.physicalKey.debugName) {
                case "Backspace":
                  {
                    notifierRead.removeText();
                    break;
                  }
              }
            }*/
          },
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
                      padding:
                          EdgeInsets.symmetric(horizontal: maxWidth * 0.03),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: maxWidth * 0.045),
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
      ),
    );
  }
}
