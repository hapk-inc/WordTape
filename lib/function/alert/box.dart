import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../router/router.dart';
import 'panel.dart';

part 'box.g.dart';

BorderRadius get _radius7pt5 => BorderRadius.circular(7.5.r);

@Riverpod(keepAlive: true, dependencies: [panelController])
class AlertBox extends _$AlertBox {
  @override
  Widget build() => const SizedBox();

  @override
  set state(Widget value) {
    super.state = value;
    final PanelController panel = ref.read(panelControllerProvider);
    if (panel.isAttached) {
      if (panel.isPanelClosed && value.toString() != "SizedBox") {
        panel.open();
      }
    } else {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: _radius7pt5),
          child: ClipRRect(borderRadius: _radius7pt5, child: value),
        ),
      );
    }
  }
}
