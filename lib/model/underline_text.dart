import 'package:freezed_annotation/freezed_annotation.dart';

part 'underline_text.freezed.dart';

@Freezed()
class UnderlineText with _$UnderlineText {
  const factory UnderlineText(String text,
      {@Default("") String end, String? focus}) = _UnderlineText;
}
