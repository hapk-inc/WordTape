import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../model/word.dart';
import '../../theme/color.dart';
import 'notifier.dart';

final Logger logger = Logger();

final ChangeNotifierProviderFamily<WordNotifier, Word> wordNotifierProvider =
    ChangeNotifierProvider.family<WordNotifier, Word>(
  (ref, word) => WordNotifier(ref, word),
);

class WordNotifier extends ChangeNotifier {
  final Ref<WordNotifier> ref;
  final Word word;

  late Color _color;
  late TextEditingController _controller;
  late RiddleNotifier _notifier;
  late bool _isEnabled;
  late FocusNode _node;
  late DateTime _date;
  late int _index;

  WordNotifier(this.ref, this.word) {
    final List<String> splitter = word.id?.split("|") ?? [];
    if (splitter.isEmpty) return;

    //
    _date = DateTime.parse(splitter[0]);
    _notifier = ref.read(riddleNotifierProvider(_date));
    _index = int.parse(splitter[1]);

    //
    initV();
  }

  void initV() {
    logger.i("initV-$_index");
    _isEnabled = _index == _notifier.found.i;
    log(_isEnabled.toString());
    _node = FocusNode(canRequestFocus: _isEnabled);
    if (_isEnabled) {
      _controller = TextEditingController(text: _firstLetter(word.value));
      _color = aquaMarine;
    } else {
      if (_index < _notifier.found.i) {
        _controller = TextEditingController(text: word.value);
        _color = _index == _notifier.found.i - 1 ? azureGreen : Colors.white24;
      } else {
        _controller = TextEditingController();
        _color = Colors.white24;
      }
    }
    notifyListeners();
  }

  TextEditingController get controller => _controller;

  set controller(TextEditingController value) {
    if (_controller == value) return;
    _controller = value;
    notifyListeners();
  }

  Color get color => _color;

  String _firstLetter(String str) => str.isEmpty ? '' : str.substring(0, 1);

  bool get isEnabled => _isEnabled;

  FocusNode get node => _node;
}
