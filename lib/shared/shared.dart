import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared.g.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPref(Ref ref) async =>
    await SharedPreferences.getInstance();
