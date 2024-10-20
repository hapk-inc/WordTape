import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'underline_text.freezed.dart';

part 'underline_text.g.dart';

@Freezed()
class UnderlineText extends Equatable with _$UnderlineText {
  const UnderlineText._();

  const factory UnderlineText(String text,
      {@Default("") String end, String? focused}) = _UnderlineText;

  factory UnderlineText.fromJson(Map<String, dynamic> json) =>
      _$UnderlineTextFromJson(json);

  @override
  List<Object?> get props => [text];
}
