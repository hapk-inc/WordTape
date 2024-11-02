import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
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
    if (state == value) return;
    super.state = value;
    String str = "$value";
    debugPrint(str);
    if (str == "ePanel".tr()) return;
    final PanelController panel = ref.read(panelControllerProvider);
    final ScreenSize size = ref.read(sizeProvider);
    if (panel.isAttached && size == ScreenSize.mobile) {
      if (panel.isPanelClosed) panel.open();
    } else {
      show(value);
    }
  }

  set dialogState(PanelWidget value) => show(value);

  void show(PanelWidget value) => showDialog(
        context: navigatorKey.currentContext!,
        builder: (_) => FadeIn(
          duration: const Duration(milliseconds: 750),
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: _radius()),
            child: ClipRRect(borderRadius: _radius(), child: value),
          ),
        ),
      ).then((_) => state = const EmptyPanel());
}
