import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mock_data/mock_data.dart';

import '../../enum/enum.dart';
import '../../model/found.dart';
import '../../model/prompt.dart';
import '../../model/underline_text.dart';
import '../../model/word.dart';
import '../../theme/color.dart';
import '../../extension/extension.dart';

import '../auth/pod.dart';
import '../underline_text/pod.dart';
import 'notifier.dart';
// import 'p_notifier.dart';

const String backspace = "🔙";
const String done = "✔️";

final ChangeNotifierProviderFamily<WordNotifier, Word> wordNotifierProvider =
    ChangeNotifierProvider.family<WordNotifier, Word>(
  (ref, word) => WordNotifier(ref, word),
);

class WordNotifier extends ChangeNotifier {
  final Ref<WordNotifier> ref;
  final Word word;

  Color _color = Colors.white24;
  TextEditingController _controller = TextEditingController();
  late QuestionNotifier _notifier;
  late FocusNode _node;
  late DateTime _date;
  late int _index;
  late Logger _tracker;

  bool _enabled = false;
  bool _error = false;

  WordNotifier(this.ref, this.word) {
    _tracker = ref.read(trackerProvider);
    final List<String> splitter = word.id?.split("|") ?? [];
    if (splitter.isEmpty) return;

    //
    _date = DateTime.parse(splitter[0]);
    _notifier = ref.read(questionNotifierProvider(_date));
    _index = int.parse(splitter[1]);

    validateController(_notifier.found.i);
  }

  validateController(int i) {
    _enabled = i == _index;
    final bool done = _notifier.done;
    _node = FocusNode(canRequestFocus: _enabled);
    if (done) {
      _controller = TextEditingController(text: word.value);
      final bool didHeFound = !_notifier.found.untilNow.containsKey(_index);
      _color = didHeFound ? aquaMarine : melon;
    } else {
      _node = FocusNode(canRequestFocus: _enabled);
      if (_enabled) {
        _controller = TextEditingController(text: word.value.firstChar);
        _color = aquaMarine;
      } else {
        if (_index.isPrevPrev(i)) {
          _controller = TextEditingController(text: word.value);
          _color = _index.isPrev(i) ? azureGreen : Colors.white24;
        }
      }
    }
  }

  @override
  void addListener(VoidCallback listener) {
    ref.listen<Found>(
      questionNotifierProvider(_date).select((value) => value.found),
      (prev, next) {
        if (_index == next.i) {
          final int p = prev?.i ?? const Found().i;
          _error = next.mistake != null;
          if (_error) {
            /*_notifier.prompt = _notifier.prompt.copyWith(
              text: UnderlineText(
                "use_hint_${mockInteger(0, 7)}".tr(),
                focused: "Hint hint",
              ),
            );*/
          } else {
            // _notifier.clue = "";
            final bool isFirstFound = _index == 2 && p == 1;
            if (isFirstFound) {
              _notifier.header = UnderlineText(
                  "resume_${mockInteger(0, 5)}".tr(),
                  focused: "sequence. pattern");
            }
          }
        }
        if (!_index.isNext(next.i)) validateController(next.i);
        notifyListeners();
      },
    );
    super.addListener(listener);
  }

  TextEditingController get controller => _controller;

  Color get color => _color;

  bool get isEnabled => _enabled;

  FocusNode get node => _node;

  bool get error => _error;

  keyboardTap(String str) {
    _notifier.prompt = Prompt(
      text: ref.read(figureOutProvider), //Typing check
      state: PromptState.search,
    );
    if (str.length == 1) {
      final bool regEx = RegExp(r'^[a-zA-Z0-9]$').hasMatch(str);
      if (regEx) insertChar(str);
    } else {
      if (str == "ENTER") {
        if (_notifier.formKey.currentState?.validate() ?? false) {
          _notifier.validate(str);
        }
      }
      if (str == "DEL") deleteChar();
    }
  }

  Future insertChar(String str) async {
    if (word.value.length > _controller.text.length) {
      String newText = _controller.text + str;
      _controller = TextEditingController(text: newText);
      onTextChanged(newText);
    } else {
      _tracker.i("Occupied Full Text");
    }
  }

  deleteChar() {
    final String text = _controller.text;
    final String newText = text.substring(0, text.length - 1);
    _controller = TextEditingController(text: newText);
    onTextChanged(newText);
  }

  onTextChanged(String? text) async {
    if (text == null) return;
    String txt = text.toUpperCase();
    final User? user = ref.read(runningUserProvider).value;
    if (user == null) ref.read(userLoginProvider);
    String exact = word.value;
    if (!txt.startsWith(exact.firstChar) || txt.isEmpty) {
      _controller.value = _controller.value.copyWith(
        text: exact.firstChar,
        selection: TextSelection.fromPosition(const TextPosition(offset: 1)),
      );
    } else {
      _controller.value = _controller.value.copyWith(
        text: txt,
        selection: TextSelection.fromPosition(
          TextPosition(offset: text.length),
        ),
      );
    }
    notifyListeners();
  }

  String? validator(String? value) {
    if (value == null) return null;
    final int len = value.length;
    final bool filled = len == word.value.length;
    if (filled) return null;
    _error = true;
    final UnderlineText err = ref.read(fillTextProvider);
    _notifier.prompt = Prompt(text: err, state: PromptState.error);
    return err.text;
  }
}
