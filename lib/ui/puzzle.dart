import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../logic/panel_controller.dart';
import '../logic/puzzle/puzzle_notifier.dart';
import '../logic/size.dart';
import '../model/found.dart';
import '../model/puzzle.dart';
import 'puzzle/puzzle_hint.dart';
import 'puzzle/my_keyboard.dart';
import 'puzzle/puzzle_text_field.dart';
import 'theme/colors.dart';
import 'theme/font_function.dart';

final DefaultTextTheme textTheme = DefaultTextTheme();

EdgeInsets _commonPuzzlePadding(BoxConstraints constraint) {
  final double maxWidth = constraint.maxWidth;
  return EdgeInsets.only(left: maxWidth * 0.03, right: maxWidth * 0.018);
}

@RoutePage()
class PuzzlePage extends ConsumerWidget {
  final String id;
  const PuzzlePage({@PathParam('id') required this.id, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      puzzleNotifierProvider(id).select(
        (value) {
          final Found found = value.found;
          return found.i;
        },
      ),
      (previous, next) {
        ref.read(puzzleNotifierProvider(id)).validateController();
      },
    );

    return LayoutBuilder(
      builder: (_, constraint) {
        final double maxHeight = constraint.maxHeight;
        log(DateTime.now().timeZoneName);
        return KeyboardListener(
          onKeyEvent: (KeyEvent event) {
            //log("onKeyEvent==$event");

            //add notifier and filter with keyLabel so that same keyEvent no raising
          },
          focusNode: FocusNode(),
          child: Container(
            color: seaWhite,
            height: maxHeight,
            padding: _commonPuzzlePadding(constraint),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    height: maxHeight * 0.06,
                    alignment: Alignment.center,
                    child: const _CloseButton(),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: _commonPuzzlePadding(constraint),
                    height: maxHeight * 0.15,
                    alignment: Alignment.topLeft,
                    child: PuzzleHint(id),
                  ),
                  //Gap(maxHeight * 0.015),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    height: maxHeight * 0.48,
                    child: PuzzleBoard(id),
                  ),
                  Gap(maxHeight * 0.054),
                  const MyKeyboard(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

////////////////////////////////
class _CloseButton extends ConsumerWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String size = ref.watch(sizeProvider);
    final PanelController panelController = ref.read(panelControllerProvider);
    return InkWell(
      onTap: () {
        if (panelController.isAttached) {
          if (panelController.isPanelOpen) panelController.close();
        } else {
          context.router.maybePop();
        }
      },
      child: size == "mobile"
          ? const Icon(Icons.keyboard_arrow_down)
          : const Icon(Icons.close),
    );
  }
}

class PuzzleBoard extends ConsumerWidget {
  final String id;
  const PuzzleBoard(this.id, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PuzzleNotifier puzzleNotifier = ref.watch(puzzleNotifierProvider(id));
    final Puzzle puzzle = puzzleNotifier.puzzle;
    return LayoutBuilder(
      builder: (_, constraint) {
        final double maxHeight = constraint.maxHeight;
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: puzzle.words.length,
          padding: _commonPuzzlePadding(constraint),
          itemBuilder: (_, index) {
            final String text = puzzle.words[index].value;
            return Container(
              height: maxHeight / 6,
              alignment: Alignment.centerLeft,
              child: PuzzleTextField(index, name: text),
            );
          },
        );
      },
    );
  }
}
