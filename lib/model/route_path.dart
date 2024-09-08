import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_path.freezed.dart';

@freezed
class RoutePath with _$RoutePath {
  const factory RoutePath(String path, {Object? arg}) = _RoutePath;

  @override
  bool operator ==(Object other) => other is RoutePath && other.path == path;
}
