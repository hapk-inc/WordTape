import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:mock_data/mock_data.dart';
import '../extension/extension.dart';

import 'date_converter.dart';

import 'found.dart';
import 'word.dart';

part 'riddle.freezed.dart';
part 'riddle.g.dart';

@freezed
class Riddle extends Equatable with _$Riddle {
  const Riddle._();

  //@JsonSerializable(explicitToJson: true)
  const factory Riddle({
    @JsonKey() @DateConverter() required DateTime date,
    required List<Word> words,
    @Default(0) int played,
    @Default(0) int win,
    @JsonKey(includeIfNull: false) String? id,
  }) = _Riddle;

  factory Riddle.fromJson(Map<String, dynamic> json) => _$RiddleFromJson(json);

  factory Riddle.fromFirestore(Map<String, dynamic> json) {
    Riddle riddle = Riddle.fromJson(json);
    final List<Word> w = [];
    for (int index = 0; index < riddle.words.length; index++) {
      final x = riddle.words[index];
      final String str = DateFormat('yyyy-MM-dd').format(riddle.date);
      w.add(x.copyWith(id: "$str|$index"));
    }
    riddle = riddle.copyWith(words: w);
    return riddle;
  }

  factory Riddle.fromRandom() {
    final DateTime now = DateTime.now();
    return Riddle(
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
  List<Object?> get props => [id];
}
