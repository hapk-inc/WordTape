import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final puzzlePanelProvider = StateNotifierProvider<PuzzlePanel, Widget>(
  (ref) => PuzzlePanel(),
);

class PuzzlePanel extends StateNotifier<Widget> {
  PuzzlePanel() : super(const SizedBox());

  @override
  set state(Widget value) => super.state = value;
}
