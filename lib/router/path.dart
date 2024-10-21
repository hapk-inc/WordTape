import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../extension/extension.dart';
import '../model/route_path.dart';

part 'path.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
class PathNotifier extends _$PathNotifier {
  @override
  RoutePath build() => RoutePath(path: "/", date: DateTime.now().convert());

  @override
  set state(RoutePath value) {
    if (super.state == value) return;
    super.state = value;
  }
}
