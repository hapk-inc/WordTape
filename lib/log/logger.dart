import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logger.g.dart';

@Riverpod(keepAlive: true)
Logger log(LogRef ref) => Logger();
