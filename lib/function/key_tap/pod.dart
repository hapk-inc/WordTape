import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../extension/extension.dart';
import '../date/date.dart';
import '../question/notifier.dart';
import '../question/word_notifier.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [SelectedDate])
class KeyTapNotifier extends _$KeyTapNotifier {
  @override
  KeyEvent? build() => null;

  @override
  set state(KeyEvent? value) {
    if (value == null) return;
    super.state = value;
    final String str = value.logicalKey.keyLabel;
    final DateTime date = ref.read(selectedDateProvider).convert();
    final QuestionNotifier notifier = ref.read(questionNotifierProvider(date));
    if (notifier.focusedWord != null) {
      final WordNotifier word =
          ref.read(wordNotifierProvider(notifier.focusedWord!));
      word.listenTap(str);
    }
  }
}
