import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wordtape/riddle/word_notifier.dart';

import '../firestore/pod.dart';
import '../model/found.dart';
import '../model/riddle.dart';
import '../model/date_ext.dart';
import '../model/underline_text.dart';
import '../model/word.dart';
import '../underline_text/pod.dart';

final ChangeNotifierProviderFamily<RiddleNotifier, DateTime>
    riddleNotifierProvider =
    ChangeNotifierProvider.family<RiddleNotifier, DateTime>(
  (ref, date) => RiddleNotifier(ref, date: date),
);

class RiddleNotifier extends ChangeNotifier {
  final Ref<RiddleNotifier> ref;
  final DateTime date;
  //
  late Riddle? _riddle;
  late Logger logger;
  late Found _found = Found(date: date);
  late UnderlineText _title;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  RiddleNotifier(this.ref, {required this.date}) {
    final DateTime d = date.convert();
    logger = Logger();
    _riddle = ref.watch(riddleFirestoreDateArgProvider(date: d)).value;
    _title = riddle == null
        ? ref.read(noRiddleProvider)
        : ref.read(titleProvider).copyWith(end: "?");
  }

  UnderlineText get title => _title;

  Found get found => _found;

  Riddle? get riddle => _riddle;

  GlobalKey<FormState> get formKey => _formKey;

  List<Word> get searchWord {
    if (_riddle == null) return [];
    return [
      _riddle!.words[_found.i - 1],
      _riddle!.words[_found.i],
    ];
  }

  Word get _activeWord => riddle!.words[_found.i];

  TextEditingController get _activeController {
    if (riddle == null) return TextEditingController();
    return ref.read(wordNotifierProvider(_activeWord)).controller;
  }

  bool get _enableDone {
    if (riddle == null) return false;
    return _activeWord.value.length == _activeController.text.length;
  }

  addText(String str) {
    if (!_enableDone) {
      String newText = _activeController.text + str;
      ref.read(wordNotifierProvider(_activeWord)).controller =
          TextEditingController(text: newText);
      onTextChanged(newText);
      notifyListeners();
    }
  }

  removeText() {
    final String text = _activeController.text;
    final String newText = text.substring(0, text.length - 1);
    ref.read(wordNotifierProvider(_activeWord)).controller =
        TextEditingController(text: newText);
    onTextChanged(newText);
    notifyListeners();
  }

  onTextChanged(String newText) {
    String exact = _activeWord.value;
    if (!newText.startsWith(_firstLetter(exact)) || newText.isEmpty) {
      ref.read(wordNotifierProvider(_activeWord)).controller.value =
          _activeController.value.copyWith(
        text: _firstLetter(exact),
        selection: TextSelection.fromPosition(const TextPosition(offset: 1)),
      );
    }
  }

  Future<void> validate() async {
    bool isValid = _activeWord.value == _activeController.text;
    if (!isValid) {
      _updateMistake(_activeController.text);
    } else {
      _incrementFound();
    }
  }

  _updateMistake(String text) {
    _found = _found.copyWith(lastFound: DateTime.now(), mistake: text);
    notifyListeners();
  }

  Future<void> _incrementFound() async {
    _found = _found.copyWith(
      i: _found.i + 1,
      lastFound: DateTime.now(),
      mistake: null,
    );
    logger.i("$_found");
    final bool everyFound = _riddle?.isCompleted(_found.i) ?? false;

    notifyListeners();
  }

  String _firstLetter(String str) => str.isEmpty ? '' : str.substring(0, 1);
}
