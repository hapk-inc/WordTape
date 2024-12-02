import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'route_path.freezed.dart';

@freezed
class RoutePath extends Equatable with _$RoutePath {
  const RoutePath._();
  const factory RoutePath({required String path, required DateTime date}) =
      _RoutePath;

  @override
  List<Object?> get props => [path, date];
}
