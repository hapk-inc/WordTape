import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/puzzle/bloc.dart';

import '../../model/found.dart';
import '../../model/puzzle.dart';
import '../../enum/enum.dart';

final ChangeNotifierProvider<FoundNotifier> foundNotifierProvider =
    ChangeNotifierProvider<FoundNotifier>(
  (ref) => FoundNotifier(ref),
);

class FoundNotifier extends ChangeNotifier {
  late Puzzle puzzle;
  List<WordValidate> _validate = [];
  List<bool?> _hintArr = [];
  final Ref<FoundNotifier> ref;
  late Found _found;

  FoundNotifier(this.ref) {
    puzzle = ref.read(puzzleProvider).value!;

    for (var word in puzzle.words) {
      _validate.add(WordValidate.idle);
      _hintArr.add(word.hint == null ? null : false);
    }
    //_validate = List.filled(puzzle.words.length, WordValidate.idle);

    _found = ref.read(selectedFoundProvider).value ?? Found(id: puzzle.id);

    debugPrint("27--$_found");
    updateValidate(init: true);
  }

  updateValidate({bool init = false}) {
    if (found.isCompleted) {
      for (int i = 0; i <= 5; i++) {
        if (i == 0) {
          _validate[i] = WordValidate.alreadyFilled;
        } else if ((found.revealed ?? []).contains(puzzle.words[i].value)) {
          _validate[i] = WordValidate.revealed;
        } else {
          _validate[i] = WordValidate.filled;
        }
      }
    } else {
      final int currentIndex = _found.i;
      for (int i = 0; i < currentIndex; i++) {
        _validate[i] =
            init || i == 0 || _validate[i] == WordValidate.alreadyFilled
                ? WordValidate.alreadyFilled
                : (_found.revealed ?? []).contains(puzzle.words[i].value)
                    ? WordValidate.revealed
                    : WordValidate.filled;
      }
      _validate[currentIndex - 1] = WordValidate.previous;
      if (currentIndex != 6) {
        _validate[currentIndex] =
            _found.mistake != null ? WordValidate.error : WordValidate.focused;
      }
    }
    debugPrint("60--$_validate");
  }

  correctOne() {
    final int index = _found.i;
    final DateTime now = DateTime.now();
    _found = _found.copyWith(i: index + 1, lastFound: now, mistake: null);
    notifyListeners();
  }

  wrongOne(String value) {
    final DateTime now = DateTime.now();
    _found = _found.copyWith(lastFound: now, mistake: value);
    notifyListeners();
  }

  revealWord(String word) {
    final int index = _found.i;
    final DateTime now = DateTime.now();
    final List<String> reveal = _found.revealed ?? [];
    reveal.add(word);
    _found = _found.copyWith(
      i: index + 1,
      lastFound: now,
      mistake: null,
      revealed: reveal,
    );
    notifyListeners();
  }

  updateHintFlag() {
    _hintArr[found.i] = true;
    notifyListeners();
  }

  Found get found => _found;

  List<WordValidate> get validate => _validate;

  List<bool?> get hintArr => _hintArr;
}
