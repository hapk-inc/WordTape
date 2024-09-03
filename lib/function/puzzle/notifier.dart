import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../model/found.dart';
import '../../model/puzzle.dart';
import '../../model/word.dart';
import '../local/found.dart';
import '../logger/pod.dart';
import 'pod.dart';

final ChangeNotifierProviderFamily<PuzzleNotifier, DateTime>
    puzzleNotifierProvider =
    ChangeNotifierProvider.family<PuzzleNotifier, DateTime>(
        (ref, date) => PuzzleNotifier(ref, date: date)..construct);

class PuzzleNotifier extends ChangeNotifier {
  final Ref<PuzzleNotifier> ref;
  final DateTime date;
  Puzzle? _puzzle;
  late Found _found;
  List<TextEditingController> _pinController = [];
  late List<FocusNode> _nodes;
  late Logger logger;

  //
  // final LocalFound localFound = LocalFound();

  PuzzleNotifier(this.ref, {required this.date}) {
    debugPrint("29==$date");
  }

  Future get construct async {
    logger = ref.read(logProvider);
    logger.i("Construct Puzzle");
    //final DateTime date = ref.read(chosenDateProvider);
    _puzzle = await ref.read(puzzleFromDateProvider(date).future) ??
        Puzzle.fromRandom();
    logger.i(_puzzle);
    if (_puzzle != null) {
      _found = await ref.read(foundFromPuzzleProvider(_puzzle!).future) ??
          Found(id: _puzzle!.id, date: _puzzle!.date);
    }

    validateController();
    constructNodes();
    notifyListeners();
  }

  validateController() {
    logger.i("Running ValidateController $_found");
    _pinController = List.generate(
      _puzzle?.words.length ?? 0,
      (index) {
        late TextEditingController controller;
        final String text = _puzzle!.words[index].value;
        if (index < _found.i) {
          controller = TextEditingController(text: text);
        } else if (index == _found.i) {
          controller = TextEditingController(text: getFirstLetter(text));
        } else {
          controller = TextEditingController(text: '');
        }
        return controller;
      },
    );
    if (_found.lastFound != null) {
      LocalFound().insert(_found);
      ref.invalidate(foundFromPuzzleProvider(_puzzle!));
      notifyListeners();
    }
  }

  constructNodes() {
    _nodes = List.generate(_puzzle?.words.length ?? 0, (_) => FocusNode());
  }

  Puzzle get puzzle => _puzzle ?? Puzzle.fromRandom();

  TextEditingController get activeController => _pinController.isEmpty
      ? TextEditingController()
      : _pinController[_found.i];

  FocusNode get activeNode => _nodes[_found.i];

  TextEditingController? textController(Word word) {
    if (_puzzle == null) return null;
    final int index = _puzzle!.words.indexOf(word);
    if (index.isNegative) return null;
    return _pinController[index];
  }

  FocusNode focusNode(int i) => _nodes[i];

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
    if (_puzzle == null) return;
    String exact = _puzzle!.words[_found.i].value;
    if (!newText.startsWith(getFirstLetter(exact)) || newText.isEmpty) {
      _pinController[_found.i].value = activeController.value.copyWith(
        text: getFirstLetter(exact),
        selection: TextSelection.fromPosition(const TextPosition(offset: 1)),
      );
    }
  }

  bool get enableDone {
    if (_puzzle == null) return false;
    return _puzzle!.words[_found.i].value.length ==
        activeController.text.length;
  }

  String getFirstLetter(String str) => str.isEmpty ? '' : str.substring(0, 1);

  Future<void> validate() async {
    if (_puzzle == null) return;
    bool isValid = _puzzle!.words[_found.i].value == activeController.text;
    if (!isValid) {
      logger.i("CORRECT WORD = ${_puzzle!.words[_found.i].value}");
    } else {
      incrementFound();
    }
  }

  Future<void> incrementFound() async {
    logger.d("Increment Found");
    _found = _found.copyWith(i: _found.i + 1, lastFound: DateTime.now());
    logger.d("$_found");
    //localFound.insert(_found);

    //
    final bool everyFound = _puzzle?.isCompleted(_found.i) ?? false;
    if (everyFound) {
    } else {
      notifyListeners();
    }
  }

  Found get found => _found;

  String get nextWord {
    if (_puzzle == null) return "";
    final int currentTrack = _found.i;
    List<Word> list = _puzzle!.words;
    final String str =
        "${list[currentTrack - 1].value} ${list[currentTrack].value}";
    logger.d("Next-Word $str");
    return str;
  }
}
