import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true)
Future<PackageInfo> package(PackageRef ref) async => PackageInfo.fromPlatform();
