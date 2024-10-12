import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:mock_data/mock_data.dart';
import '../extension/extension.dart';

import 'converter/date_converter.dart';

import 'found.dart';
import 'word.dart';

part 'question.freezed.dart';
part 'question.g.dart';

@freezed
class Question extends Equatable with _$Question {
  const Question._();

  //@JsonSerializable(explicitToJson: true)
  const factory Question({
    @JsonKey() @DateConverter() required DateTime date,
    required List<Word> words,
    @Default([]) List<String> played,
    @Default(0) int win,
    @JsonKey(includeIfNull: false) String? id,
  }) = _Riddle;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  factory Question.fromFirestore(Map<String, dynamic> json) {
    Question riddle = Question.fromJson(json);
    final List<Word> w = [];
    for (int index = 0; index < riddle.words.length; index++) {
      final x = riddle.words[index];
      final String str = DateFormat('yyyy-MM-dd').format(riddle.date);
      w.add(x.copyWith(id: "$str|$index"));
    }
    riddle = riddle.copyWith(words: w);
    return riddle;
  }

  factory Question.fromRandom() {
    final DateTime now = DateTime.now();
    return Question(
      date: now.convert(),
      words: List.generate(6, (_) => Word(value: mockName().toUpperCase())),
      id: mockString(8),
    );
  }

  bool isCompleted(int length) => words.length == length;

  List<Word> searchWord(Found found) {
    if (isCompleted(found.i)) return [];
    return [words[found.i - 1], words[found.i]];
  }

  String answer(Found found) {
    final List<Word> words = searchWord(found);
    if (words.isEmpty) return "";
    return words.fold("", (prev, e) => "$prev ${e.value}").trim();
  }

  @override
  List<Object?> get props => [id, played, win, date];
}
