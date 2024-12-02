import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'word.freezed.dart';
part 'word.g.dart';

@freezed
class Word extends Equatable with _$Word {
  const Word._();

  @JsonSerializable(includeIfNull: false)
  const factory Word({
    @JsonKey(fromJson: fromJson) required String value,
    @JsonKey(includeIfNull: false) String? note,
    @JsonKey(includeIfNull: false) List<String>? hints,
    @JsonKey(includeIfNull: false, includeToJson: false, includeFromJson: false)
    String? id,
  }) = _Word;

  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);

  @override
  List<Object?> get props => [id, value];
}

String fromJson(String str) => str.toUpperCase();
