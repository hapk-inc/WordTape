import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wordtape/model/word.dart';

import '../../model/found.dart';
import '../../model/puzzle.dart';
import '../gen_ai/pod.dart';
import '../local/pod.dart';
import '../logger/pod.dart';
import 'pod.dart';

final ChangeNotifierProviderFamily<PuzzleNotifier, DateTime>
    puzzleNotifierProvider =
    ChangeNotifierProvider.family<PuzzleNotifier, DateTime>(
  (ref, date) => PuzzleNotifier(ref, date: date)..construct,
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
  late String _hint;

  PuzzleNotifier(this.ref, {required this.date}) {
    logger = ref.read(logProvider);
    _puzzle = ref.read(puzzleDateArgProvider(date: date)).value ??
        Puzzle.fromRandom();
    _found =
        ref.read(foundDateArgProvider(date: date)).value ?? Found(date: date);
    validateController();

    _nodes = List.generate(_puzzle.words.length, (_) => FocusNode());
  }

  validateController() async {
    logger.i("Running ValidateController $_found");
    _hint = ref.read(recallNextProvider);
    if (!_puzzle.isCompleted(_found.i)) generateNewHint();
    //setHint();
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
    if (_found.lastFound != null) {
      ref.read(sqFoundProvider).insert(_found);
      ref.invalidate(foundDateArgProvider(date: date));
      notifyListeners();
    }
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
      logger.i("CORRECT WORD = ${_puzzle.words[_found.i].value}");
    } else {
      incrementFound();
    }
  }

  Future<void> incrementFound() async {
    _found = _found.copyWith(i: _found.i + 1, lastFound: DateTime.now());

    final bool everyFound = _puzzle.isCompleted(_found.i);

    if (everyFound) {
    } else {
      generateNewHint();
      notifyListeners();
    }
  }

  String firstLetter(String str) => str.isEmpty ? '' : str.substring(0, 1);

  TextEditingController get activeController =>
      _pinController.isEmpty || _puzzle.isCompleted(_found.i)
          ? TextEditingController()
          : _pinController[_found.i];

  FocusNode get activeNode => _nodes[_found.i];

  String get hint => _hint;

  generateNewHint() {
    bool hasHint = _puzzle.words[_found.i].hint != null;
    if (hasHint) {
      final String h = _puzzle.words[_found.i].hint!;
      _hint = h;
    } else {
      final String recall = ref.read(recallNextProvider);
      _hint = ref
          .watch(createHintProvider(word: _puzzle.nextWord(_found)))
          .maybeWhen(
            data: (data) => data,
            orElse: () => recall,
            error: (error, stackTrace) {
              logger.e("GEMINI ERROR", error: error, stackTrace: stackTrace);
              return recall;
            },
          );
    }
  }

  TextEditingController textController(int index) => _pinController[index];

  FocusNode focusNode(int i) => _nodes[i];

  Puzzle get puzzle => _puzzle;

  Future get construct async {}

  Found get found => _found;

  bool get isStarted => _found.i != 1;

  bool isPrevious(Word word) => _puzzle.words[_found.i - 1] == word;
}
