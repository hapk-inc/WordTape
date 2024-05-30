import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../model/d_panel.dart';

part 'panel.g.dart';

@Riverpod(keepAlive: true)
PanelController panelController(PanelControllerRef ref) => PanelController();

@riverpod
class DPanelWidget extends _$DPanelWidget {
  @override
  DPanel build() => DPanel(height: 210.r);
}
