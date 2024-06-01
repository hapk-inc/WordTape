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

  String get shareCode {
    final String text = words.fold(
      "",
      (prev, e) {
        final String value = e.value;
        String x = prev;
        if (words.first.value != value) {
          String firstLetter = value.split('').first;
          String dashed = value.split('').fold(
            "",
            (prev, e) {
              if (prev.isEmpty && e == firstLetter) return e;
              return "$prev ⎯ ";
            },
          );
          x += dashed;
        } else {
          x = value;
        }
        //
        if (e != words.last) x += "\n";
        return x;
      },
    );
    //debugPrint("76-- $text");
    return "WORDTAPE No.234\n\n$text";
  }
/*  String shareText() {
    debugPrint("69--${puzzle.puzzle.length}");
    final String text = puzzle.puzzle.fold(
      "",
      (prev, word) {
        final String value = word.word;
        String x = prev;
        if (puzzle.puzzle.first.word != value) {
          String firstLetter = value.characters.first;
          String dashed = value.characters.fold("", (prev, e) {
            if (prev.isEmpty && e == firstLetter) return e;
            return "$prev ⎯ ";
          });
          x += dashed;
        } else {
          x = value;
        }

        if (word != puzzle.puzzle.last) x += "\n";
        return x;
      },
    );
    debugPrint("76-- $text");
    return "WORDTAPE No.234\n\n$text";
  }*/
}
