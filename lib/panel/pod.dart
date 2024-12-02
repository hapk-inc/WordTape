import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wordtape/theme/color.dart';

import '../enum/enum.dart';
import '../router/router.dart';
import '../shared/shared.dart';
import 'widget.dart';

part 'pod.g.dart';

BorderRadius _radius({double ar = 7.5}) => BorderRadius.circular(ar.r);

@Riverpod(keepAlive: true, dependencies: [])
PanelController panelController(Ref ref) => PanelController();

@Riverpod(keepAlive: true, dependencies: [panelController, size])
class PanelNotifier extends _$PanelNotifier {
  @override
  PanelWidget? build() => null;

  @override
  set state(PanelWidget? value) {
    if ("$state" == "$value") return;
    super.state = value;
    final ScreenSize size = ref.read(sizeProvider);
    if (value != null) {
      if (size == ScreenSize.mobile && !kIsWeb) {
        final PanelController panel = ref.read(panelControllerProvider);
        if (panel.isAttached) if (panel.isPanelClosed) panel.open();
      } else {
        show(value);
      }
    } else {
      final PanelController panel = ref.read(panelControllerProvider);
      if (panel.isAttached) {
        if (panel.isPanelOpen) panel.close();
      }
    }
  }

  show(PanelWidget value) => showDialog(
        context: navigatorKey.currentContext!,
        builder: (_) => FadeIn(
          duration: const Duration(milliseconds: 750),
          child: Dialog(
            backgroundColor: midnightGreen,
            shape: RoundedRectangleBorder(borderRadius: _radius()),
            child: ClipRRect(borderRadius: _radius(), child: value),
          ),
        ),
      ).then(
        (_) async {
          switch ("$state") {
            case "InstructionDialog":
              {
                final SharedPreferences pref =
                    await ref.read(sharedPrefProvider.future);
                pref.setBool('how_to_play', true);
                break;
              }
          }
          return state = null;
        },
      );
}
