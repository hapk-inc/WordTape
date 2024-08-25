import 'package:freezed_annotation/freezed_annotation.dart';

part 'found.freezed.dart';
part 'found.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class Found with _$Found {
  const Found._();

  @JsonSerializable(includeIfNull: false)
  const factory Found({
    @Default(0) int i,
    String? mistake,
    List<String>? revealed,
    DateTime? lastFound,
    @JsonKey(includeToJson: false) String? id, //later include in database
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
