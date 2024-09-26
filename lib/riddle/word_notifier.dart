import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/word.dart';
import '../theme/color.dart';
import 'notifier.dart';

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

  WordNotifier(this.ref, this.word) {
    final List<String> splitter = word.id?.split("|") ?? [];
    if (splitter.isEmpty) return;

    //
    DateTime date = DateTime.parse(splitter[0]);
    _notifier = ref.read(riddleNotifierProvider(date));
    final int index = int.parse(splitter[1]);

    //
    _isEnabled = index == _notifier.found.i;
    _node = FocusNode(canRequestFocus: _isEnabled);
    if (_isEnabled) {
      _controller = TextEditingController(text: _firstLetter(word.value));
      _color = aquaMarine;
    } else {
      if (index < _notifier.found.i) {
        _controller = TextEditingController(text: word.value);
        _color = azureGreen;
      } else {
        _controller = TextEditingController();
        _color = Colors.white60;
      }
    }
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
