import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
DotEnv env(EnvRef ref) => throw UnimplementedError();
