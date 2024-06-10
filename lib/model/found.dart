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
    @JsonKey(includeIfNull: false) int? hintUsed,
    @JsonKey(includeIfNull: false) int? rank,
    //

    @JsonKey(includeToJson: false) //later need to include in database
    String? id,
  }) = _Found;

  factory Found.fromJson(Map<String, dynamic> json) => _$FoundFromJson(json);

  Map<String, dynamic> get toFirestore => toJson()..remove('id');

  bool get isCompleted => i == 6;

  bool get fullScore => revealed == null;
}
