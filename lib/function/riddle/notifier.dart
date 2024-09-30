import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../../model/tip.dart';
import '../../model/underline_text.dart';

import '../../model/found.dart';
import '../../model/riddle.dart';
import '../../model/word.dart';
import '../firestore/pod.dart';
import '../sqlite/pod.dart';
import '../underline_text/pod.dart';
import 'riddle_hint.dart';
import 'word_notifier.dart';

final Logger logger = Logger();

const String backspace = "🔙";
const String done = "✔️";

final ChangeNotifierProviderFamily<RiddleNotifier, DateTime>
    riddleNotifierProvider =
    ChangeNotifierProvider.family<RiddleNotifier, DateTime>(
  (ref, date) => RiddleNotifier(ref, date: date)..init(),
);

class RiddleNotifier extends ChangeNotifier {
  final Ref<RiddleNotifier> ref;
  final DateTime date;
  Riddle? _riddle;
  late Found _found;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late bool _completed = false;
  late Tip _tip = const Tip(text: "", t: "");

  RiddleNotifier(this.ref, {required this.date}) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateStr = formatter.format(date);
    logger.i("RiddleNotifier for $dateStr");
    //_found = Found(date: date);
  }

  List<Word> get searchWord {
    if (_riddle == null) return [];
    if (_riddle?.id == null) return [];
    return [
      _riddle!.words[_found.i - 1],
      _riddle!.words[_found.i],
    ];
  }

  Word get activeWord => _riddle!.words[_found.i];

  String get answer => _riddle?.answer(_found) ?? "";

  bool get _enableDone {
    if (_riddle == null || _activeController == null) return false;
    return activeWord.value.length == _activeController!.text.length;
  }

  TextEditingController? get _activeController {
    if (_riddle == null) return null;
    return ref.read(wordNotifierProvider(activeWord)).controller;
  }

  FocusNode get activeNode => ref.read(wordNotifierProvider(activeWord)).node;

  Found get found => _found;

  List<String> get highlightedChar {
    if (!_found.soFar.containsKey(_found.i)) return [];
    List<String> map = List.from(_found.soFar[_found.i]);
    return map;
  }

  UnderlineText get title {
    if (_riddle == null) return ref.read(noRiddleProvider);
    return _found.i == 1
        ? ref.read(welcomeUserProvider)
        : ref.read(resumeProvider);
  }

  GlobalKey<FormState> get formKey => _formKey;

  Riddle? get riddle => _riddle;

  Tip get tip => _tip;

  Future addText(String str) async {
    if (!_enableDone) {
      String newText = _activeController!.text + str;
      ref.read(wordNotifierProvider(activeWord)).controller =
          TextEditingController(text: newText);
      onTextChanged(newText);
    }
  }

  removeText() {
    final String text = _activeController!.text;
    final String newText = text.substring(0, text.length - 1);
    ref.read(wordNotifierProvider(activeWord)).controller =
        TextEditingController(text: newText);
    onTextChanged(newText);
  }

  onTextChanged(String newText) {
    String exact = activeWord.value;
    if (!newText.startsWith(_firstLetter(exact)) || newText.isEmpty) {
      ref.read(wordNotifierProvider(activeWord)).controller.value =
          _activeController!.value.copyWith(
        text: _firstLetter(exact),
        selection: TextSelection.fromPosition(const TextPosition(offset: 1)),
      );
    }
    notifyListeners();
  }

  Future<void> validate() async {
    if (_activeController == null) return;
    bool isValid = activeWord.value == _activeController!.text;
    if (!isValid) {
      _updateMistake(_activeController!.text);
    } else {
      ref.read(riddleHintProvider(date).notifier).state =
          ref.read(correctAnswerProvider);
      await _incrementFound();
    }
    notifyListeners();
  }

  Future<void> _incrementFound() async {
    final DateTime now = DateTime.now();
    _found = _found.copyWith(i: _found.i + 1, lastFound: now, mistake: null);
    logger.i("$_found");
    final bool everyFound = _riddle?.isCompleted(_found.i) ?? false;
    _completed = everyFound;
  }

  _updateMistake(String text) {
    _found = _found.copyWith(lastFound: DateTime.now(), mistake: text);
  }

  listenTap(String str) {
    if (str.length == 1) {
      final bool regEx = RegExp(r'^[a-zA-Z0-9]$').hasMatch(str);
      if (regEx) addText(str);
    } else {
      if (str == "Backspace" || str == backspace) removeText();
      if (str == "Enter" || str == done) _formKey.currentState!.validate();
      logger.i(str);
    }
  }

  createTip() {
    if (_found.soFar.containsKey(_found.i)) {
      final List<String> soFar = List<String>.from(_found.soFar[_found.i]);
      logger.i(_found.soFar.toString());
      _tip = Tip.fromWord(activeWord.value, soFar: soFar);
      updateSoFar(_tip);
    } else {
      _tip = Tip.fromWord(activeWord.value);
      updateSoFar(_tip);
    }
    notifyListeners();
  }

  updateSoFar(Tip? tip) {
    if (tip == null) return;
    Map<int, dynamic> map = Map<int, dynamic>.from(_found.soFar);
    map.update(_found.i, (value) => [...value, tip.t], ifAbsent: () => [tip.t]);
    _found = _found.copyWith(
      soFar: map,
      mistake: null,
      lastFound: DateTime.now(),
    );
  }

  String _firstLetter(String str) => str.isEmpty ? '' : str.substring(0, 1);

  bool compareHighlighter(String? value) {
    if (value == null) return false;
    final List<String> splitter = value.split("");
    Map<int, dynamic> map = _found.soFar;
    if (!map.containsKey(_found.i)) return true;
    final List<String> soFar = List<String>.from(_found.soFar[_found.i]);
    return soFar.every((char) => splitter.contains(char));
  }

  Future init() async {
    _riddle =
        await ref.watch(riddleFirestoreDateArgProvider(date: date).future);
    if (_riddle != null) {
      _found = await ref.watch(sqFoundArgProvider(id: _riddle!.id).future) ??
          Found(date: date, id: _riddle!.id);
      logger.i("$_found");
    }
    notifyListeners();
  }
}
