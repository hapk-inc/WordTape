import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wordtape/model/word.dart';

import '../../model/found.dart';
import '../../model/puzzle.dart';
import '../local/pod.dart';
import '../logger/pod.dart';
import 'pod.dart';

final ChangeNotifierProviderFamily<PuzzleNotifier, DateTime>
    puzzleNotifierProvider =
    ChangeNotifierProvider.family<PuzzleNotifier, DateTime>(
  (ref, date) => PuzzleNotifier(ref, date: date),
);

class PuzzleNotifier extends ChangeNotifier {
  final Ref<PuzzleNotifier> ref;
  final DateTime date;
  //
  late Puzzle _puzzle;
  late Found _found;
  List<TextEditingController> _pinController = [];
  late List<FocusNode> _nodes;
  late Logger logger;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _hint;

  PuzzleNotifier(this.ref, {required this.date}) {
    logger = ref.read(loggerProvider);
    _puzzle = ref.read(puzzleDateArgProvider(date: date)).value ??
        Puzzle.fromRandom();
    _found =
        ref.read(foundDateArgProvider(date: date)).value ?? Found(date: date);
    validateController();

    _nodes = List.generate(_puzzle.words.length, (_) => FocusNode());
  }

  validateController() async {
    logger.i("Running ValidateController $_found");
    _pinController = List.generate(
      _puzzle.words.length,
      (index) {
        final String text = _puzzle.words[index].value;
        if (index < _found.i) {
          return TextEditingController(text: text);
        } else if (index == _found.i) {
          return TextEditingController(text: firstLetter(text));
        }
        return TextEditingController();
      },
    );
  }

  updateLocally() {
    ref.read(sqFoundProvider).insert(_found);
    ref.invalidate(foundDateArgProvider(date: date));
  }

  bool get enableDone =>
      _puzzle.words[_found.i].value.length == activeController.text.length;

  addText(String str) {
    if (!enableDone) {
      String newText = activeController.text + str;
      _pinController[_found.i] = TextEditingController(text: newText);
      onTextChanged(newText);
      notifyListeners();
    } else {
      logger.i("ALREADY FILLED = ${activeController.text}");
    }
  }

  removeText() {
    final String text = activeController.text;
    final String newText = text.substring(0, text.length - 1);
    _pinController[_found.i] = TextEditingController(text: newText);
    onTextChanged(newText);
    notifyListeners();
  }

  onTextChanged(String newText) {
    String exact = _puzzle.words[_found.i].value;
    if (!newText.startsWith(firstLetter(exact)) || newText.isEmpty) {
      _pinController[_found.i].value = activeController.value.copyWith(
        text: firstLetter(exact),
        selection: TextSelection.fromPosition(const TextPosition(offset: 1)),
      );
    }
  }

  Future<void> validate() async {
    bool isValid = _puzzle.words[_found.i].value == activeController.text;
    if (!isValid) {
      updateMistake(activeController.text);
    } else {
      incrementFound();
    }
  }

  updateMistake(String text) {
    _found = _found.copyWith(lastFound: DateTime.now(), mistake: text);
    notifyListeners();
  }

  GlobalKey<FormState> get formKey => _formKey;

  Future<void> incrementFound() async {
    _found = _found.copyWith(
      i: _found.i + 1,
      lastFound: DateTime.now(),
      mistake: null,
    );
    logger.i("$_found");
    final bool everyFound = _puzzle.isCompleted(_found.i);

    if (everyFound) {
    } else {
      notifyListeners();
    }
  }

  String firstLetter(String str) => str.isEmpty ? '' : str.substring(0, 1);

  TextEditingController get activeController =>
      _pinController.isEmpty || _puzzle.isCompleted(_found.i)
          ? TextEditingController()
          : _pinController[_found.i];

  FocusNode get activeNode => _nodes[_found.i];

  String? get hint => _hint;

  set hint(String? value) {
    if (_hint == value) return;
    _hint = value;
    notifyListeners();
  }

  TextEditingController textController(int index) => _pinController[index];

  FocusNode focusNode(int i) => _nodes[i];

  Puzzle get puzzle => _puzzle;

  Found get found => _found;

  bool get isStarted => _found.i != 1;

  bool isPrevious(Word word) => _puzzle.words[_found.i - 1] == word;

  String get next => _puzzle.nextWord(_found);

  String get mistakeCombination {
    final String result =
        "${_puzzle.words[_found.i - 1].value} ${_found.mistake}";
    log(result);
    return result;
  }

  String? get localHint => _puzzle.words[_found.i].hint;
}
