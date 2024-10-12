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
    required DateTime date,
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

  String foundTrack(int count) => i == 1
      ? "-"
      : i == count
          ? "DONE"
          : "PENDING";

  @override
  // TODO: implement props
  List<Object?> get props => [id, i, mistake, date, lastFound];

  factory Found.fromRiddle(Question riddle) => Found(
        date: riddle.date,
        id: riddle.id,
      );
}

/*
Map<int, dynamic> _fromJson(dynamic json) {
  if (json.isEmpty) return {};
  return {};
  //final Map<String, dynamic> map = Map<String, dynamic>.from(jsonDecode(json));
  //return map;
}

String _toJson(Map<int, dynamic> object) {
  Logger().d(object);
  Map<String, dynamic> map = {};
  for (MapEntry m in object.entries) {
    map["${m.key}"] = m.value;
  }
  final String str = jsonEncode(map);
  return str;
}
*/
