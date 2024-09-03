import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pod.g.dart';

enum ScreenSize { mobile, tab, pc }

enum ValidateAuth { notLogged, guest, inGame }

enum ValidateRemote { yes, no, failed }

enum NeedToDo { plain, onClick, find }

//////////////////////////////////////////////////

ScreenSize validateSize() {
  final double mW = 360.w;
  if (mW < 420.r) return ScreenSize.mobile;
  return mW < 720.r ? ScreenSize.tab : ScreenSize.pc;
}

@Riverpod(keepAlive: true, dependencies: [])
ScreenSize size(SizeRef ref) => ScreenSize.mobile;

@Riverpod(keepAlive: true)
class RemoteNotifier extends _$RemoteNotifier {
  @override
  ValidateRemote build() => ValidateRemote.no;
}
