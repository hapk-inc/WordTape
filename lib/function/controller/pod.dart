import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true)
PanelController panelController(PanelControllerRef ref) => PanelController();

@Riverpod(keepAlive: true)
class PuzzlePanel extends _$PuzzlePanel {
  @override
  Widget build() => const SizedBox();
}
