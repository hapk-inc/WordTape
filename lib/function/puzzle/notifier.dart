import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../model/found.dart';
import '../../model/puzzle.dart';
import '../../model/tip.dart';
import '../../model/word.dart';
import '../gen_ai/pod.dart';
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
  late bool _isCompleted = false;
  Tip? tip;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PuzzleNotifier(this.ref, {required this.date}) {
    log("Initiating Notifier", name: "puzzle");
    logger = ref.read(loggerProvider);
    _puzzle = ref.read(puzzleDateArgProvider(date: date)).value ??
        Puzzle.fromRandom();
    _found =
        ref.read(foundDateArgProvider(date: date)).value ?? Found(date: date);
    validateController();

    _nodes = List.generate(_puzzle.words.length, (_) => FocusNode());
    final bool everyFound = _puzzle.isCompleted(_found.i);
    _isCompleted = everyFound;
  }

  validateController() async {
    logger.i("Running ValidateController $_found");
    _pinController = _isCompleted
        ? List.generate(
            _puzzle.words.length,
            (i) {
              final String text = _puzzle.words[i].value;
              return TextEditingController(text: text);
            },
          )
        : List.generate(
            _puzzle.words.length,
            (index) {
              final String text = _puzzle.words[index].value;
              if (index < _found.i) {
                return TextEditingController(text: text);
              } else if (index == _found.i) {
                return TextEditingController(text: _firstLetter(text));
              }
              return TextEditingController();
            },
          );
  }

  bool get _enableDone =>
      _puzzle.words[_found.i].value.length == activeController.text.length;

  addText(String str) {
    if (!_enableDone) {
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
    String exact = currentWord.value;
    if (!newText.startsWith(_firstLetter(exact)) || newText.isEmpty) {
      _pinController[_found.i].value = activeController.value.copyWith(
        text: _firstLetter(exact),
        selection: TextSelection.fromPosition(const TextPosition(offset: 1)),
      );
    }
  }

  Future<void> validate() async {
    tip = null;
    bool isValid = currentWord.value == activeController.text;
    if (!isValid) {
      _updateMistake(activeController.text);
    } else {
      _incrementFound();
    }
  }

  _updateMistake(String text) {
    _found = _found.copyWith(lastFound: DateTime.now(), mistake: text);
    notifyListeners();
  }

  GlobalKey<FormState> get formKey => _formKey;

  Future<void> _incrementFound() async {
    _found = _found.copyWith(
      i: _found.i + 1,
      lastFound: DateTime.now(),
      mistake: null,
    );
    logger.i("$_found");
    final bool everyFound = _puzzle.isCompleted(_found.i);
    isCompleted = everyFound;
    notifyListeners();
  }

  String _firstLetter(String str) => str.isEmpty ? '' : str.substring(0, 1);

  TextEditingController get activeController =>
      _pinController.isEmpty || _puzzle.isCompleted(_found.i)
          ? TextEditingController()
          : _pinController[_found.i];

  FocusNode get activeNode => _isCompleted ? FocusNode() : _nodes[_found.i];

  TextEditingController textController(int index) => _pinController[index];

  Puzzle get puzzle => _puzzle;

  Found get found => _found;

  bool isPrevious(Word word) => _puzzle.words[_found.i - 1] == word;

  String get next => _puzzle.nextWord(_found);

  String get mistakeCombination {
    final String result =
        "${_puzzle.words[_found.i - 1].value} ${_found.mistake}";
    log(result);
    return result;
  }

  String? get localHint => currentWord.hint;

  bool get isCompleted => _isCompleted;

  Word get currentWord => _puzzle.words[_found.i];

  set isCompleted(bool value) {
    if (_isCompleted == value) return;
    _isCompleted = value;
    notifyListeners();
  }

  generateTip() async {
    if (_found.soFar.containsKey(_found.i)) {
      final Map m = _found.soFar[_found.i];
      log(_found.soFar.toString(), name: "soFar");
      log(m.toString(), name: "soFar");

      tip = await ref.read(generateTipProvider(
              str: currentWord.value, soFar: List.castFrom(m.values.toList()))
          .future);
      updateSoFar(tip);
    } else {
      tip = await ref.read(generateTipProvider(str: currentWord.value).future);
      updateSoFar(tip);
      log(tip?.text ?? "");
    }
  }

  updateSoFar(Tip? tip) {
    Map<int, dynamic> map = Map<int, dynamic>.from(_found.soFar);
    map.update(
      _found.i,
      (value) {
        Map m = value;
        m[tip?.position] = tip?.t;
        return m;
      },
      ifAbsent: () => {tip?.position: tip?.t},
    );
    _found = _found.copyWith(soFar: map);
    notifyListeners();
  }
}
