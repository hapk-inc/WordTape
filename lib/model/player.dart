import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
class Player extends Equatable with _$Player {
  const Player._();

  @JsonSerializable(includeIfNull: false)
  const factory Player({
    String? name,
    String? nickName,
    num? rollNo,
    String? email,
    String? photoURL,
    DateTime? nowTime,
    DateTime? created,
    String? source,

    //
    String? id,
  }) = _Player;

  @override
  List<Object?> get props => [rollNo, id];
}
