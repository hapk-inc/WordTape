import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mock_data/mock_data.dart';
import 'package:equatable/equatable.dart';

import '../enum/enum.dart';
import 'underline_text.dart';

part 'prompt.freezed.dart';

@freezed
class Prompt extends Equatable with _$Prompt {
  const Prompt._();

  const factory Prompt(
      {required UnderlineText text, required PromptState state}) = _Prompt;

  @override
  List<Object?> get props => [text, state];
}
