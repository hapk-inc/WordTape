import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../model/panel_widget.dart';
import '../../ui/dashboard/login_dialog.dart';

part 'panel.g.dart';

@Riverpod(keepAlive: true)
PanelController dashboardPanel(DashboardPanelRef ref) => PanelController();

@Riverpod(keepAlive: true)
PanelController boardPanel(BoardPanelRef ref) => PanelController();

@Riverpod(keepAlive: true)
class PanelNotifier extends _$PanelNotifier {
  @override
  PanelWidget build() => PanelWidget(
        height: 210.r,
        child: const LoginDialogState(),
      );

  @override
  PanelWidget get state => super.state;

  @override
  set state(PanelWidget value) => super.state = value;
}
