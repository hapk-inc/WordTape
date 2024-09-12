import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'route_path.freezed.dart';

@freezed
class RoutePath extends Equatable with _$RoutePath {
  const RoutePath._();

  const factory RoutePath({@Default("/") String path, Object? arg}) =
      _RoutePath;

  @override
  // TODO: implement props
  List<Object?> get props => [path, arg];
}
