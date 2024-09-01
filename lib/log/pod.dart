import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true)
Logger log(LogRef ref) => Logger();
