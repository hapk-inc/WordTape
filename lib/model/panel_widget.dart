import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../ui/dashboard/login_dialog.dart';

part 'panel_widget.freezed.dart';

@freezed
class PanelWidget with _$PanelWidget {
  const factory PanelWidget({
    @Default(210) double height,
    @Default(LoginDialogState()) Widget child,
  }) = _PanelWidget;
}
