import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../ui/dashboard/login_dialog.dart';

part 'd_panel.freezed.dart';

@freezed
class DPanel with _$DPanel {
  const factory DPanel({
    @Default(210) double height,
    @Default(LoginDialogState()) Widget child,
  }) = _DPanel;
}
