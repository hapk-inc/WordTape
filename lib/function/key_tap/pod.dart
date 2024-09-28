import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../model/date_ext.dart';
import '../riddle/notifier.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true)
class KeyTapNotifier extends _$KeyTapNotifier {
  @override
  KeyEvent? build() => null;

  @override
  set state(KeyEvent? value) {
    if (value == null) return;
    super.state = value;
    final String str = value.logicalKey.keyLabel;
    final DateTime date = DateTime.now().convert();
    ref.read(riddleNotifierProvider(date)).listenTap(str);
  }
}

/*
@riverpod
void listenTap(ListenTapRef ref, String str) async {
  final DateTime date = DateTime.now().convert();
  final RiddleNotifier notifier = ref.read(riddleNotifierProvider(date));
  if (str.length == 1) {
    final bool regEx = RegExp(r'^[a-zA-Z0-9]$').hasMatch(str);
    if (regEx) await notifier.addText(str);
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
*/
