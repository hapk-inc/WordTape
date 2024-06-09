import 'package:freezed_annotation/freezed_annotation.dart';

part 'word_event.freezed.dart';
part 'word_event.g.dart';

@freezed
class WordEvent with _$WordEvent {
  const factory WordEvent({
    required String id,
    String? word,
    String? user,
    @Default("web") String method,
  }) = _WordEvent;

  factory WordEvent.fromJson(Map<String, dynamic> json) =>
      _$WordEventFromJson(json);
}
