import 'package:freezed_annotation/freezed_annotation.dart';

part 'found.freezed.dart';
part 'found.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class Found with _$Found {
  const Found._();

  @JsonSerializable(includeIfNull: false)
  const factory Found({
    @Default(1) int i,
    String? mistake,
    List<String>? revealed,
    DateTime? lastFound,
    required DateTime date,
    @JsonKey(includeIfNull: false) String? id, //later include in database
  }) = _Found;

  factory Found.fromJson(Map<String, dynamic> json) => _$FoundFromJson(json);

  //factory Found.initial() => const Found();

  String foundTrack(int count) => i == 1
      ? "-"
      : i == count
          ? "DONE"
          : "PENDING";
}
