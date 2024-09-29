import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

part 'panel.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
PanelController panelController(PanelControllerRef ref) => PanelController();
