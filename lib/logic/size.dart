import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'size.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
String size(SizeRef ref) => 'mobile';
