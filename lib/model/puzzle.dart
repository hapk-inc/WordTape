import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:mock_data/mock_data.dart';

import 'puzzle_date_converter.dart';
import 'word.dart';

part 'puzzle.freezed.dart';
part 'puzzle.g.dart';

@freezed
class Puzzle with _$Puzzle {
  const Puzzle._();

  //@JsonSerializable(explicitToJson: true)
  const factory Puzzle({
    @JsonKey() @PuzzleDateConverter() required DateTime date,
    required List<Word> words,
    @Default(0) int played,
    @Default(0) int win,
    @JsonKey(includeIfNull: false) String? id,
  }) = _Puzzle;

  factory Puzzle.fromJson(Map<String, dynamic> json) => _$PuzzleFromJson(json);

  factory Puzzle.fromRandom() => Puzzle(
        date: DateTime.now(),
        words:
            List.generate(6, (index) => Word(value: mockName().toUpperCase())),
        id: mockString(8),
      );

  bool isCompleted(int length) => words.length == length;

/*  static String toDateTimeStr(DateTime value) {
    final String dateStr = DateFormat('yyyy-MM-dd').format(value);
    return dateStr;
  }*/
}
