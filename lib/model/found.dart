import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'converter/until_now.dart';
import 'question.dart';

part 'found.freezed.dart';
part 'found.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class Found extends Equatable with _$Found {
  const Found._();

  @JsonSerializable(includeIfNull: false)
  const factory Found({
    @Default(1) int i,
    String? mistake,
    @UntilNowConverter() @Default(<int, dynamic>{}) Map<int, dynamic> untilNow,
    DateTime? lastFound,
    @JsonKey(includeFromJson: false) DateTime? date,
    @JsonKey(includeIfNull: false) String? id, //later include in database
  }) = _Found;

  factory Found.fromJson(Map<String, dynamic> json) => _$FoundFromJson(json);

  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> map = toJson();
    map
      ..remove('id')
      ..remove('date');
    if (untilNow.isEmpty) map.remove('soFar');
    return map;
  }

  @override
  List<Object?> get props => [id, i, mistake, date];

  factory Found.fromRiddle(Question q) => Found(date: q.date, id: q.id);
}
