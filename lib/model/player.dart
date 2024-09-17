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
    String? source,

    //
    @JsonKey(includeFromJson: false, includeToJson: false) String? id,
  }) = _Player;

  @override
  List<Object?> get props => [rollNo, id];

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  factory Player.fromFirestore(Map<String, dynamic> json, {String? id}) =>
      _$PlayerFromJson(json).copyWith(id: id);

  factory Player.newUser(User fUser) {
    debugPrint(fUser.toString());
    return Player(
      nickName:
          fUser.displayName ?? mockName() + mockInteger(0, 1000).toString(),
      rollNo: mockInteger(100000, 99999999),
      nowTime: fUser.metadata.lastSignInTime,
      created: fUser.metadata.creationTime,
      source: kIsWeb
          ? "web"
          : fUser.providerData[0].providerId == "gc.apple.com"
              ? "iOS"
              : "Android",
    );
  }
}
