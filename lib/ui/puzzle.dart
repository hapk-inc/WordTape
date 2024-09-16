import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../function/keyboard/pod.dart';
import '../function/puzzle/notifier.dart';
import '../function/puzzle/pod.dart';
import '../model/found.dart';
import '../model/puzzle.dart';
import '../model/word.dart';
import '../router/pod.dart';
import 'puzzle/custom_keyboard.dart';
import 'puzzle/hint.dart';
import 'puzzle/light_btn.dart';
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

    ref.listenManual<Found>(
      puzzleNotifierProvider(date).select<Found>((value) => value.found),
      (previous, next) async {
        final notifier = ref.read(puzzleNotifierProvider(date));
        if ((previous?.i ?? 1) != next.i) notifier.validateController();
        final AsyncData<Found> data = AsyncData(next);
        ref.read(foundDateArgProvider(date: date).notifier).state = data;
      },
    );

    ref.listenManual<bool>(
      puzzleNotifierProvider(date).select<bool>((value) => value.isCompleted),
      (_, next) async {
        if (next) ref.read(routerProvider).pop();
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PuzzleNotifier notifier = ref.read(puzzleNotifierProvider(date));
    final Puzzle puzzle = notifier.puzzle;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return ColoredBox(
      color: midnightGreen,
      child: SafeArea(
        bottom: false,
        child: KeyboardListener(
          focusNode: notifier.activeNode,
          autofocus: true,
          onKeyEvent: (KeyEvent? value) {
            if (value is KeyDownEvent || value is KeyRepeatEvent) {
              ref.read(keyEventNotifierProvider.notifier).state = value;
            }
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double maxHeight = constraints.maxHeight;
              final double maxWidth = constraints.maxWidth;
              final double h_03 = maxHeight * 0.03;
              final double w_03 = maxWidth * 0.03;
              return Form(
                key: notifier.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppBar(
                        toolbarHeight: h_03 * 3,
                        actions: const [LightBtn()],
                        titleTextStyle: textTheme.displayMedium?.copyWith(
                          color: seaWhite,
                        ),
                        title: FadeIn(
                          delay: const Duration(milliseconds: 750),
                          child: const Text("WORDTAPE"),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        height: h_03 * 5,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: w_03 * 1.5),
                        child: const PuzzleHint(),
                      ),
                      ...List.generate(
                        puzzle.words.length,
                        (index) {
                          final Word word = puzzle.words[index];
                          return WordTextField(
                            index,
                            word,
                            height: h_03 * 2.88,
                          );
                        },
                      ),
                      Gap(h_03 * 0.6),
                      const CustomKeyboard(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
