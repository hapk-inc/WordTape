import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

part 'bloc.g.dart';

@riverpod
double deviceSize(DeviceSizeRef ref) => 900.h / 360.w;

@Riverpod(keepAlive: true)
PanelController panelController(PanelControllerRef ref) => PanelController();

@Riverpod(keepAlive: true)
class PanelNotifier extends _$PanelNotifier {
  @override
  Widget build() => const SizedBox();

  @override
  set state(Widget value) => super.state = value;
}
