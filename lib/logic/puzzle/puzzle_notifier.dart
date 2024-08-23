import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/found.dart';
import '../../model/puzzle.dart';

final ChangeNotifierProviderFamily<PuzzleNotifier, String>
    puzzleNotifierProvider =
    ChangeNotifierProvider.family<PuzzleNotifier, String>(
        (ref, id) => PuzzleNotifier(ref, id: id)..construct);

class PuzzleNotifier extends ChangeNotifier {
  final Ref<PuzzleNotifier> ref;
  final String id;
  late Puzzle _puzzle;
  late Found _found;
  late List<TextEditingController> _list;
  PuzzleNotifier(this.ref, {required this.id});

  Future get construct async {
    log("Construct Puzzle");
    _puzzle = Puzzle.fromRandom();
    _found = const Found();
    _list = List.generate(
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
  }

  Puzzle get puzzle => _puzzle;

  TextEditingController get activeController => _list[_found.i];

  TextEditingController textController(int i) => _list[i];

  addText(String str) {
    String newText = activeController.text + str;
    _list[_found.i] = TextEditingController(text: newText);
    onTextChanged(newText);
    notifyListeners();
  }

  removeText() {
    final String text = activeController.text;
    final String newText = text.substring(0, text.length - 1);
    _list[_found.i] = TextEditingController(text: newText);
    onTextChanged(newText);
    notifyListeners();
  }

  onTextChanged(String newText) {
    String exact = _puzzle.words[_found.i].value;
    if (!newText.startsWith(getFirstLetter(exact)) || newText.isEmpty) {
      _list[_found.i].value = activeController.value.copyWith(
        text: getFirstLetter(exact),
        selection: TextSelection.fromPosition(
          const TextPosition(offset: 1),
        ),
      );
    }
  }

  String getFirstLetter(String str) => str.isEmpty ? '' : str.substring(0, 1);
}
