import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../router/pod.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
PanelController panelController(PanelControllerRef ref) => PanelController();

@Riverpod(keepAlive: true, dependencies: [panelController])
class WidgetPanel extends _$WidgetPanel {
  @override
  Widget build() => const SizedBox();

  @override
  set state(Widget value) {
    super.state = value;
    final PanelController panel = ref.watch(panelControllerProvider);
    log(value.toString());
    if (panel.isAttached) {
      if (panel.isPanelClosed && value.toString() != "SizedBox") {
        panel.open();
      }
    } else {
      log("Panel Not Attached");
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.5.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7.5.r),
            child: value,
          ),
        ),
      );
    }
  }
}
