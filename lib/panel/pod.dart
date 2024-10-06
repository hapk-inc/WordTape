import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../enum/enum.dart';
import '../router/router.dart';
import 'widget.dart';

part 'pod.g.dart';

BorderRadius _radius({double ar = 7.5}) => BorderRadius.circular(ar.r);

@Riverpod(keepAlive: true, dependencies: [])
PanelController panelController(PanelControllerRef ref) => PanelController();

@Riverpod(keepAlive: true, dependencies: [panelController, size])
class PanelNotifier extends _$PanelNotifier {
  @override
  PanelWidget build() => const EmptyPanel();

  @override
  set state(PanelWidget value) {
    if (value.toString() == const EmptyPanel().toString()) return;
    super.state = value;
    final PanelController panel = ref.read(panelControllerProvider);
    final ScreenSize size = ref.read(sizeProvider);
    if (panel.isAttached && size == ScreenSize.mobile) {
      if (panel.isPanelClosed) panel.open();
    } else {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: _radius()),
          child: ClipRRect(borderRadius: _radius(), child: value),
        ),
      );
    }
  }
}
