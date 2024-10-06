import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../extension/extension.dart';
import '../date/date.dart';
import '../riddle/notifier.dart';
import '../riddle/word_notifier.dart';

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
    final RiddleNotifier notifier = ref.read(riddleNotifierProvider(date));
    final WordNotifier word =
        ref.read(wordNotifierProvider(notifier.focusedWord!));
    word.listenTap(str);
  }
}
