import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mock_data/mock_data.dart';

import 'date_converter.dart';
import 'word.dart';

part 'puzzle.freezed.dart';
part 'puzzle.g.dart';

@freezed
class Puzzle with _$Puzzle {
  const Puzzle._();

  //@JsonSerializable(explicitToJson: true)
  const factory Puzzle({
    @JsonKey() @DateConverter() required DateTime date,
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

  int get puzzleNo {
    final DateTime jun10 = DateTime(2024, 6, 10);
    return date.difference(jun10).inDays;
  }
}
