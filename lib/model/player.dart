import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:mock_data/mock_data.dart';

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
    @Default("web") String? source,
    String? avatar,

    //
    @JsonKey(includeFromJson: false, includeToJson: false) String? id,
  }) = _Player;

  @override
  List<Object?> get props => [rollNo, id, avatar];

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  factory Player.fromFirestore(Map<String, dynamic> json, {String? id}) =>
      _$PlayerFromJson(json).copyWith(id: id);

  factory Player.newUser(User fUser) {
    final String name = fUser.displayName ?? "Player";
    final UserMetadata metadata = fUser.metadata;

    Player player = Player(
      name: name,
      nickName: "$name${mockInteger(0, 1000)}",
      rollNo: mockInteger(100000, 99999999),
      nowTime: metadata.lastSignInTime,
      created: metadata.creationTime,
      avatar: mockString(6, 'a'),
    );

    if (!kIsWeb) {
      player = player.copyWith(
        source: fUser.providerData[0].providerId == "gc.apple.com"
            ? "iOS"
            : "Android",
      );
    }

    return player;
  }
}
