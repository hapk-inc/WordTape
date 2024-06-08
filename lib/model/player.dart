import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
class Player extends Equatable with _$Player {
  const Player._();

  @JsonSerializable(includeIfNull: false)
  const factory Player({
    @Default("User#") String name,
    String? rName,
    num? userId,
    String? email,
    String? photoURL,

    //
    //String? appVersion,
    DateTime? nowTime,
    String? id,
    String? source,
  }) = _Player;

  @override
  List<Object?> get props => [id, name, userId];

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}
