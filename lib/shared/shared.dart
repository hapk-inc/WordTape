import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared.g.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> shared(SharedRef ref) async =>
    await SharedPreferences.getInstance();
