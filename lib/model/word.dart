import 'package:freezed_annotation/freezed_annotation.dart';

part 'word.freezed.dart';
part 'word.g.dart';

@freezed
class Word with _$Word {
  @JsonSerializable(includeIfNull: false)
  const factory Word({
    required String value,
    String? note,
    String? hint,
    //
    //@JsonKey(includeToJson: false, includeFromJson: false)
    //@Default(WordValidate.idle)
    //WordValidate validate,
  }) = _Word;

  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);
}
