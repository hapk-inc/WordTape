import 'package:freezed_annotation/freezed_annotation.dart';

part 'found.freezed.dart';
part 'found.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class Found with _$Found {
  const Found._();

  //@JsonSerializable(includeIfNull: false)
  const factory Found({
    @Default(1) int i,
    String? mistake,
    @JsonKey(includeIfNull: false) List<String>? revealed,
    DateTime? lastFound,
    @JsonKey(includeToJson: false) //later need to include in database
    String? id,
  }) = _Found;

  factory Found.fromJson(Map<String, dynamic> json) => _$FoundFromJson(json);

  //factory Found.initial() => const Found();

  Found incrementFound() => Found(
        i: i + 1,
        lastFound: DateTime.now(),
        id: id,
        mistake: null,
        revealed: revealed,
      );
}
