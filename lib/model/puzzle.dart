import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mock_data/mock_data.dart';

import 'word.dart';

part 'puzzle.freezed.dart';
part 'puzzle.g.dart';

@freezed
class Puzzle with _$Puzzle {
  const factory Puzzle({
    required DateTime date,
    required List<Word> words,
    @Default([]) List<String> users,
    @JsonKey(includeToJson: false, includeFromJson: false) String? id,
  }) = _Puzzle;

  factory Puzzle.fromJson(Map<String, dynamic> json) => _$PuzzleFromJson(json);

  factory Puzzle.fromRandom() => Puzzle(
        date: DateTime.now(),
        //puzzle: List.from(list.map((e) => Word(value: mockName()))),
        words: List.generate(6, (index) => Word(value: mockName())),
        id: mockString(8),
      );
}
