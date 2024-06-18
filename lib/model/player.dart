import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mock_data/mock_data.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
class Player extends Equatable with _$Player {
  const Player._();

  @JsonSerializable(includeIfNull: false)
  const factory Player({
    String? name,
    String? rName,
    num? userId,
    String? email,
    String? photoURL,

    //
    //String? appVersion,
    DateTime? nowTime,
    DateTime? createdAt,
    String? id,
    String? source,
  }) = _Player;

  @override
  List<Object?> get props => [id, name, userId];

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  factory Player.newUser() {
    final DateTime now = DateTime.now();
    Player player = Player(
      source: kIsWeb ? "web" : "app",
      nowTime: now,
      userId: mockInteger(100, 999999999),
    );
    return player;
  }
}
