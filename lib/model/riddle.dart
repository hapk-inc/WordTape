import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mock_data/mock_data.dart';

import 'date_converter.dart';
import 'date_ext.dart';
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

  factory Riddle.fromRandom() {
    final DateTime now = DateTime.now();
    return Riddle(
      date: now.convert(),
      words: List.generate(6, (_) => Word(value: mockName().toUpperCase())),
      id: mockString(8),
    );
  }

  @override
  List<Object?> get props => [id];
}
