import 'package:freezed_annotation/freezed_annotation.dart';

import '../enum/enum.dart';

part 'word.freezed.dart';
part 'word.g.dart';

@freezed
class Word with _$Word {
  const factory Word({
    required String value,
    String? note,
    final String? hint,

    //
    @JsonKey(includeIfNull: false, includeToJson: false, includeFromJson: false)
    @Default(WordValidate.idle)
    WordValidate validate,
  }) = _Word;

  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);
}
