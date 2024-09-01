import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'screen_size.g.dart';

enum ScreenSize { mobile, tab, pc }

ScreenSize validateSize() {
  final double mW = 360.w;
  if (mW < 420.r) return ScreenSize.mobile;
  return mW < 720.r ? ScreenSize.tab : ScreenSize.pc;
}

@Riverpod(keepAlive: true, dependencies: [])
ScreenSize size(SizeRef ref) => ScreenSize.mobile;
