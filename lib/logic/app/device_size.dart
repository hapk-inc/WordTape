import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_size.g.dart';

@riverpod
double deviceSize(DeviceSizeRef ref) => 900.h / 360.w;
