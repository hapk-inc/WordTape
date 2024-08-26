import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../logic/panel_controller.dart';
import '../../logic/puzzle/puzzle_key.dart';
import '../../logic/puzzle/puzzle_panel.dart';
import '../../model/puzzle.dart';
import '../../router/my_router.dart';
import '../puzzle.dart';

class PlayButton extends ConsumerWidget {
  final Puzzle? puzzle;
  const PlayButton(this.puzzle, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PanelController panelController = ref.read(panelControllerProvider);

    return ElevatedButton(
      onPressed: puzzle == null
          ? null
          : () {
              final String id = puzzle?.id ?? "xyz";
              if (id == "xyz") log("Empty Puzzle ID");
              ref.read(puzzleKeyProvider.notifier).state = id;
              if (kIsWeb || !panelController.isAttached) {
                context.router.push(PuzzleRoute(id: id));
              } else {
                if (panelController.isPanelClosed) {
                  ref.read(puzzlePanelProvider.notifier).state =
                      PuzzlePage(id: id);
                  panelController.open();
                }
              }
            },
      child: const Text("Play Now"),
    );
  }
}
