import 'package:freezed_annotation/freezed_annotation.dart';

import 'underline_text.dart';

part 'word_clue.freezed.dart';

@freezed
class WordClue with _$WordClue {
  const WordClue._();

  const factory WordClue({
    required UnderlineText text,
    @Default(false) bool lastChance,
  }) = _WordClue;
}
