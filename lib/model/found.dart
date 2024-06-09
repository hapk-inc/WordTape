import 'package:freezed_annotation/freezed_annotation.dart';

part 'found.freezed.dart';
part 'found.g.dart';

@freezed
class Found with _$Found {
  const Found._();

  @JsonSerializable(includeIfNull: false)
  const factory Found({
    @Default(1) int i,
    String? mistake,
    @Default([]) List<String> revealed,
    DateTime? lastFound,
    int? hintUsed,
    int? rank,
    //
    String? id,
  }) = _Found;

  factory Found.fromJson(Map<String, dynamic> json) => _$FoundFromJson(json);

  Map<String, dynamic> get toFirestore => toJson()..remove('id');

  bool get isCompleted => i == 6;
}
