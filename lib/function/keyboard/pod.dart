import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wordtape/function/puzzle/notifier.dart';

import '../puzzle/pod.dart';
part 'pod.g.dart';

@Riverpod(keepAlive: true)
class KeyEventNotifier extends _$KeyEventNotifier {
  @override
  KeyEvent? build() => null;

  @override
  set state(KeyEvent? value) {
    if (value == null) return;
    super.state = value;
    final DateTime date = ref.read(selectedDateProvider);
    final String str = value.logicalKey.keyLabel;
    final PuzzleNotifier notifier = ref.read(puzzleNotifierProvider(date));
    if (str.length == 1) {
      final bool regEx = RegExp(r'^[a-zA-Z0-9]$').hasMatch(str);
      if (regEx) notifier.addText(str);
    } else {
      switch (str) {
        case "Backspace":
          {
            notifier.removeText();
            break;
          }
        case "Enter":
          {
            notifier.formKey.currentState!.validate();
          }
        default:
          {
            log(str);
          }
      }
    }
  }
}
