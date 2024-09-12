import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'word.freezed.dart';
part 'word.g.dart';

@freezed
class Word extends Equatable with _$Word {
  const Word._();

  @JsonSerializable(includeIfNull: false)
  const factory Word({
    required String value,
    @JsonKey(includeIfNull: false) String? note,
    @JsonKey(includeIfNull: false) String? hint,
  }) = _Word;

  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);

  @override
  List<Object?> get props => [value];
}
