import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

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
    @Default(0) int played,
    @Default([]) List<String> win,
    @JsonKey(includeIfNull: false) String? id,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  factory Question.fromJsonJson(Map<String, dynamic> json) {
    Question q = Question.fromJson(json);

    final List<Word> words = [];
    for (int index = 0; index < q.words.length; index++) {
      final Word x = q.words[index];
      final String str = DateFormat('yyyy-MM-dd').format(q.date);
      words.add(x.copyWith(id: "$str|$index"));
    }

    q = q.copyWith(words: words);
    return q;
  }

  factory Question.fromSnapshot(QueryDocumentSnapshot<Object?> doc) {
    final Map map = doc.data() as Map;
    final String id = doc.id;
    final Map<String, dynamic> m = Map<String, dynamic>.from(map);
    final Question q = Question.fromJsonJson(m).copyWith(id: id);
    return q;
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
