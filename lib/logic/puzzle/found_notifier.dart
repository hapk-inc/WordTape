import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordtape/model/word_event.dart';

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
  final List<WordValidate> _validate = [];
  final List<bool?> _hintArr = [];
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
    //debugPrint("60--$_validate");
  }

  correctOne() {
    debugPrint("correctOne");
    final int index = _found.i;
    final DateTime now = DateTime.now();
    final String w = puzzle.words[index].value;
    _found = _found.copyWith(i: index + 1, lastFound: now, mistake: null);
    ref.read(wordAnalyticsProvider).foundWord(
          WordEvent(id: puzzle.id ?? "Unknown-puzzle-id", word: w),
        );
    notifyListeners();
  }

  wrongOne(String value) {
    debugPrint("wrongOne");
    final DateTime now = DateTime.now();
    _found = _found.copyWith(lastFound: now, mistake: value);
    notifyListeners();
  }

  revealWord() {
    final int index = _found.i;
    final DateTime now = DateTime.now();
    final List<String> reveal = _found.revealed ?? [];
    final String w = puzzle.words[index].value;
    ref.read(wordAnalyticsProvider).revealWord(
          WordEvent(id: puzzle.id ?? "Unknown-puzzle-id", word: w),
        );
    reveal.add(w);
    _found = _found.copyWith(
      i: index + 1,
      lastFound: now,
      mistake: null,
      revealed: reveal,
    );
    notifyListeners();
  }

  updateHintFlag() {
    _hintArr[_found.i] = true;
    _found = _found.copyWith(hintUsed: (_found.hintUsed ?? 0) + 1);
    ref.read(wordAnalyticsProvider).hintUsed(
          WordEvent(
            id: puzzle.id ?? "Unknown-puzzle-id",
            word: puzzle.words[_found.i].value,
          ),
        );
    notifyListeners();
  }

  String? get wordNote => puzzle.words[_found.i].note;

  String get hint => puzzle.words[_found.i].hint ?? "";

  bool get hasHint => _hintArr[_found.i] != null;

  bool get seeHint => _hintArr[_found.i] ?? false;

  Found get found => _found;

  List<WordValidate> get validate => _validate;

  List<bool?> get hintArr => _hintArr;
}
