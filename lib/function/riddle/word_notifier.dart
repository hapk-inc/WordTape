import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wordtape/enum/enum.dart';

import '../../model/found.dart';
import '../../model/word.dart';
import '../../theme/color.dart';
import '../firestore/pod.dart';
import '../sqlite/pod.dart';
import '../../extension/extension.dart';

import '../underline_text/pod.dart';
import 'hint.dart';
import 'notifier.dart';

final Logger logger = Logger();

final ChangeNotifierProviderFamily<WordNotifier, Word> wordNotifierProvider =
    ChangeNotifierProvider.family<WordNotifier, Word>(
  (ref, word) => WordNotifier(ref, word),
);

class WordNotifier extends ChangeNotifier {
  final Ref<WordNotifier> ref;
  final Word word;

  Color _color = Colors.white24;
  TextEditingController _controller = TextEditingController();
  late RiddleNotifier _notifier;
  late FocusNode _node;
  late DateTime _date;
  late int _index;

  bool _enabled = false;
  bool _error = false;

  WordNotifier(this.ref, this.word) {
    final List<String> splitter = word.id?.split("|") ?? [];
    if (splitter.isEmpty) return;

    //
    _date = DateTime.parse(splitter[0]);
    _notifier = ref.read(riddleNotifierProvider(_date));
    _index = int.parse(splitter[1]);

    validateController(_notifier.found.i);
  }

  validateController(int i) {
    _enabled = i == _index;
    final bool done = _notifier.done;
    if (done) {
      _controller = TextEditingController(text: word.value);
      final bool didHeFound = !_notifier.found.soFar.containsKey(_index);
      _color = didHeFound ? aquaMarine : cerise;
    } else {
      _node = FocusNode(canRequestFocus: _enabled);
      if (_enabled) {
        _controller = TextEditingController(text: word.value.firstChar);
        _color = aquaMarine;
      } else {
        if (_index.isPrevPrev(i)) {
          _controller = TextEditingController(text: word.value);
          _color = _index.isPrev(i) ? azureGreen : Colors.white24;
        }
      }
    }
  }

  @override
  void addListener(VoidCallback listener) {
    ref.listen<Found>(
      riddleNotifierProvider(_date).select((value) => value.found),
      (prev, next) {
        if (_index == next.i) {
          _notifier.riddleState = RiddleState.resume;
          ref.read(sqFoundProvider).insert(next);
          final bool isFirstFound = _index == 2 && ((prev?.i ?? 0) == 1);
          if (isFirstFound) {
            ref.read(riddleFirestoreProvider).firstFound(next.id ?? "");
          }
          _error = next.mistake != null;
          final Hint hint = ref.read(hintProvider(_date).notifier);
          if (_error) {
            hint.helpUser(_notifier.answer, next.mistake);
          } else {
            if ((prev?.i ?? 0) != next.i) hint.rearrange();
          }
        }
        if (!_index.isNext(next.i)) validateController(next.i);
        notifyListeners();
      },
    );
    super.addListener(listener);
  }

  TextEditingController get controller => _controller;

  Color get color => _color;

  bool get isEnabled => _enabled;

  FocusNode get node => _node;

  bool get error => _error;

  listenTap(String str) {
    if (str.length == 1) {
      final bool regEx = RegExp(r'^[a-zA-Z0-9]$').hasMatch(str);
      if (regEx) insertChar(str);
    } else {
      if (str == "Backspace" || str == backspace) deleteChar();
      if (str == "Enter" || str == done) {
        final RiddleNotifier notifier = ref.read(riddleNotifierProvider(_date));
        notifier.formKey.currentState!.validate();
        logger.i(str);
      }
    }
  }

  Future insertChar(String str) async {
    String newText = _controller.text + str;
    _controller = TextEditingController(text: newText);
    onTextChanged(newText);
  }

  deleteChar() {
    final String text = _controller.text;
    final String newText = text.substring(0, text.length - 1);
    _controller = TextEditingController(text: newText);
    onTextChanged(newText);
  }

  onTextChanged(String newText) {
    String exact = word.value;
    if (!newText.startsWith(exact.firstChar) || newText.isEmpty) {
      _controller.value = _controller.value.copyWith(
        text: exact.firstChar,
        selection: TextSelection.fromPosition(const TextPosition(offset: 1)),
      );
    }
    notifyListeners();
  }

  String? validator(String? value) {
    log("Validating 72--");
    final int len = value?.length ?? 0;
    final bool filled = len == word.value.length;
    final Hint hint = ref.read(hintProvider(_date).notifier);

    if (filled) {
      if (_notifier.compareHighlighter(value)) {
        _notifier.validate(value!);
      } else {
        hint.state = ref.read(useHighlighterProvider);
      }
    } else {
      hint.state = ref.read(fillTextProvider);
    }
    return null;
  }
}
