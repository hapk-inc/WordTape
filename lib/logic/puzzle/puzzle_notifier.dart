import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordtape/auth/bloc.dart';
import 'package:wordtape/logic/database/local_found.dart';

import '../../model/found.dart';
import '../../model/puzzle.dart';
import '../../model/word.dart';
import '../database/local_puzzle.dart';
import '../puzzle_date.dart';
import '../selected_date.dart';

final FutureProvider<void> deleteDatabaseProvider = FutureProvider<void>(
  (ref) async => await Future.wait(
    [
      LocalFound().delete(),
      LocalPuzzle().delete(),
      ref.read(authProvider).signOut,
    ],
  ),
);

final ChangeNotifierProviderFamily<PuzzleNotifier, String>
    puzzleNotifierProvider =
    ChangeNotifierProvider.family<PuzzleNotifier, String>(
        (ref, id) => PuzzleNotifier(ref, id: id)..construct);

class PuzzleNotifier extends ChangeNotifier {
  final Ref<PuzzleNotifier> ref;
  final String id;
  late Puzzle _puzzle;
  late Found _found;
  late List<TextEditingController> _pinController;
  late List<FocusNode> _nodes;

  //
  final LocalFound localFound = LocalFound();

  PuzzleNotifier(this.ref, {required this.id});

  Future get construct async {
    log("Construct Puzzle");
    final DateTime date = ref.read(chosenDateProvider);
    _puzzle =
        ref.read(selectedPuzzleProvider(date)).value ?? Puzzle.fromRandom();
    _found =
        ref.read(selectedFoundProvider(date)).value ?? Found(id: _puzzle.id);
    validateController();
    constructNodes();
  }

  validateController() {
    log("Running ValidateController");
    _pinController = List.generate(
      _puzzle.words.length,
      (index) {
        late TextEditingController controller;
        final String text = _puzzle.words[index].value;
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
    if (_found.lastFound != null) notifyListeners();
  }

  constructNodes() {
    _nodes = List.generate(_puzzle.words.length, (_) => FocusNode());
  }

  Puzzle get puzzle => _puzzle;

  TextEditingController get activeController => _pinController[_found.i];

  FocusNode get activeNode => _nodes[_found.i];

  TextEditingController textController(int i) => _pinController[i];
  FocusNode focusNode(int i) => _nodes[i];

  addText(String str) {
    if (!enableDone) {
      String newText = activeController.text + str;
      _pinController[_found.i] = TextEditingController(text: newText);
      onTextChanged(newText);
      notifyListeners();
    } else {
      log("ALREADY FILLED = ${activeController.text}");
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
    if (!newText.startsWith(getFirstLetter(exact)) || newText.isEmpty) {
      _pinController[_found.i].value = activeController.value.copyWith(
        text: getFirstLetter(exact),
        selection: TextSelection.fromPosition(const TextPosition(offset: 1)),
      );
    }
  }

  bool get enableDone =>
      _puzzle.words[_found.i].value.length == activeController.text.length;

  String getFirstLetter(String str) => str.isEmpty ? '' : str.substring(0, 1);

  Future<void> validate() async {
    bool isValid = _puzzle.words[_found.i].value == activeController.text;
    if (!isValid) {
      log("CORRECT WORD = ${_puzzle.words[_found.i].value}");
    } else {
      incrementFound();
    }
  }

  Future<void> incrementFound() async {
    log("Increment Found");
    _found = _found.copyWith(i: _found.i + 1, lastFound: DateTime.now());
    log("$_found");
    localFound.insert(_found);

    //
    final bool everyFound = _puzzle.isCompleted(_found.i);
    if (everyFound) {
    } else {
      notifyListeners();
    }
  }

  Found get found => _found;

  String get nextWord {
    final int currentTrack = _found.i;
    List<Word> list = _puzzle.words;
    final String str =
        "${list[currentTrack - 1].value} ${list[currentTrack].value}";
    log("Next-Word $str");
    return str;
  }
}
