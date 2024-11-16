import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AutoDisposeChangeNotifierProvider<InstructionNotifier>
    instructionNotifierProvider =
    ChangeNotifierProvider.autoDispose<InstructionNotifier>(
  (_) => InstructionNotifier()..constructor,
);

class InstructionNotifier extends ChangeNotifier {
  final List<String> _words = ["WASHING", "MACHINE", "GUN"];
  final List<String> _displayed = ["WASHING"];
  int _index = 0;
  bool _isDisposed = false;

  Future<void> get constructor async {
    for (int i = 0; i < 5; i++) {
      await Future.delayed(Duration(seconds: 1));
      if (i.isEven) {
        _displayed[_index] = _words[_index];
        _index++;
      } else {
        final List<String> list = _words[_index].split('');
        for (int i = 1; i < list.length; i++) {
          list[i] = " ";
        }
        _displayed.add(list.join());
      }

      if (!_isDisposed) notifyListeners();
    }
  }

  List<String> get displayed => _displayed;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
