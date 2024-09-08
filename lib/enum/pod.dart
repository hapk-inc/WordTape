import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pod.g.dart';

enum ScreenSize { mobile, tab, pc }

enum ValidateAuth { renovation, notLogged, guest, loggedIn, inGame }

enum NeedToDo { plain, onClick, find }

//////////////////////////////////////////////////

ScreenSize validateSize() {
  final double mW = 360.w;
  if (mW < 420.r) return ScreenSize.mobile;
  return mW < 750.r ? ScreenSize.tab : ScreenSize.pc;
}

@Riverpod(keepAlive: true, dependencies: [])
ScreenSize size(SizeRef ref) => ScreenSize.mobile;
