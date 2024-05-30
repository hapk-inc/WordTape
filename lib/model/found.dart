import 'package:freezed_annotation/freezed_annotation.dart';

part 'found.freezed.dart';
part 'found.g.dart';

@freezed
class Found with _$Found {
  @JsonSerializable(includeIfNull: false)
  const factory Found({
    @Default(1) int rowNo,
    @JsonKey(includeIfNull: false) String? mistake,
    DateTime? lastFound,
    //
    @JsonKey(includeIfNull: false) String? id,
  }) = _Found;

  factory Found.fromJson(Map<String, dynamic> json) => _$FoundFromJson(json);
}
