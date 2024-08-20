import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mock_data/mock_data.dart';

import 'word.dart';

part 'puzzle.freezed.dart';
part 'puzzle.g.dart';

@freezed
class Puzzle with _$Puzzle {
  const Puzzle._();

  const factory Puzzle({
    required DateTime date,
    required List<Word> words,
    @Default(0) int count,
    @Default(0) int winCount,
    @JsonKey(includeToJson: false, includeFromJson: false) String? id,
  }) = _Puzzle;

  factory Puzzle.fromJson(Map<String, dynamic> json) => _$PuzzleFromJson(json);

  factory Puzzle.fromRandom() => Puzzle(
        date: DateTime.now(),
        words:
            List.generate(6, (index) => Word(value: mockName().toUpperCase())),
        id: mockString(8),
      );
}
