import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../../model/date_ext.dart';

import '../../model/found.dart';
import '../../model/riddle.dart';
import '../../model/underline_text.dart';
import '../../model/word.dart';
import '../firestore/pod.dart';
import '../gen_ai/pod.dart';
import '../underline_text/pod.dart';
import 'word_notifier.dart';

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
  bool _completed = false;

  RiddleNotifier(this.ref, {required this.date}) {
    log("Init RiddleNotifier $date");
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

  FocusNode get activeNode => ref.read(wordNotifierProvider(_activeWord)).node;

  bool get completed => _completed;

  Future addText(String str) async {
    if (!_enableDone) {
      String newText = _activeController.text + str;
      ref.read(wordNotifierProvider(_activeWord)).controller =
          TextEditingController(text: newText);
      onTextChanged(newText);
    }
  }

  removeText() {
    final String text = _activeController.text;
    final String newText = text.substring(0, text.length - 1);
    ref.read(wordNotifierProvider(_activeWord)).controller =
        TextEditingController(text: newText);
    onTextChanged(newText);
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
      await _incrementFound();
    }
  }

  _updateMistake(String text) {
    _found = _found.copyWith(lastFound: DateTime.now(), mistake: text);
    notifyListeners();
  }

  Future<void> _incrementFound() async {
    final DateTime now = DateTime.now();
    _found = _found.copyWith(i: _found.i + 1, lastFound: now, mistake: null);
    logger.i("$_found");
    final bool everyFound = _riddle?.isCompleted(_found.i) ?? false;
    _completed = everyFound;
  }

  String _firstLetter(String str) => str.isEmpty ? '' : str.substring(0, 1);

  List<String> get highlightedChar {
    if (!_found.soFar.containsKey(_found.i)) return [];
    List<String> map = _found.soFar[_found.i];
    return map;
  }

  String backspace = "🔙";
  String done = "✔️";

  listenTap(String str) {
    if (str.length == 1) {
      final bool regEx = RegExp(r'^[a-zA-Z0-9]$').hasMatch(str);
      if (regEx) addText(str);
    } else {
      if (str == "Backspace" || str == backspace) removeText();
      if (str == "Enter" || str == done) formKey.currentState!.validate();
      log(str);
    }
    notifyListeners();
  }

  String get hint => ref
      .watch(createHintProvider(_activeWord, _riddle?.answer(_found) ?? ""))
      .when(
        data: (data) => data,
        error: (error, stackTrace) {
          return "Some issue";
        },
        loading: () => "Loading",
      );
}
