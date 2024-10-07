import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mock_data/mock_data.dart';

import '../../enum/enum.dart';
import '../../model/tip.dart';
import '../../model/underline_text.dart';
import '../../model/found.dart';
import '../../model/riddle.dart';
import '../../model/word.dart';

//
import '../firestore/pod.dart';
import '../sqlite/pod.dart';
import '../underline_text/pod.dart';
import 'hint.dart';

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
  Tip? _tip;
  late bool _done = false;
  late UnderlineText _header = const UnderlineText("Hi");
  bool _lastChance = false;
  late RiddleState _riddleState = RiddleState.launch;

  RiddleNotifier(this.ref, {required this.date}) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateStr = formatter.format(date);
    _found = Found(date: date);
    logger.i("RiddleNotifier for $dateStr");
  }

  Future init() async {
    _riddle = await ref.watch(riddleDateArgProvider(date: date).future);

    if (_riddle != null) {
      _header = ref.read(welcomeUserProvider);
      final foundArg = sqFoundArgProvider(id: _riddle!.id);
      _found = await ref.watch(foundArg.future) ?? Found.fromRiddle(_riddle!);
      logger.i("$_found");
    }
    done = _found.i == 6;

    if (!_done) {
      debugPrint("60==");
      debugPrint(_found.i.toString());
      riddleState = _found.i == 1 ? RiddleState.launch : RiddleState.resume;
      if (_found.soFar.containsKey(_found.i)) {
        final List<String> soFar1 = List<String>.from(_found.soFar[_found.i]);
        _lastChance = focusedWord!.value.length - 1 == soFar1.length;
      }
      notifyListeners();
    } else {
      riddleState = RiddleState.completed;
    }
  }

  @override
  void addListener(VoidCallback listener) {
    ref.listen<Riddle?>(
      riddleDocProvider(date: date).select((value) => value.value),
      (previous, next) {
        logger.i("riddleDocProvider $next");
        if (next != null) {
          _riddle = next;
          notifyListeners();
        }
      },
    );
    super.addListener(listener);
  }

  bool get done => _done;

  Word? get focusedWord => _found.i == 6 ? null : _riddle?.words[_found.i];

  String get answer => _riddle?.answer(_found) ?? "";

  List<Word> get searchWord => _riddle?.searchWord(_found) ?? [];

  Found get found => _found;

  GlobalKey<FormState> get formKey => _formKey;

  Riddle? get riddle => _riddle;

  Tip? get tip => _tip;

  bool compareHighlighter(String? value) {
    if (value == null) return false;
    final List<String> splitter = value.split("");
    Map<int, dynamic> map = _found.soFar;
    if (!map.containsKey(_found.i)) return true;
    final List<String> soFar = List<String>.from(_found.soFar[_found.i]);
    return soFar.every((char) => splitter.contains(char));
  }

  @override
  void dispose() {
    logger.d("Why dispose $date");
    super.dispose();
  }

  List<String> get highlightedChar {
    if (!_found.soFar.containsKey(_found.i)) return [];
    List<String> map = List.from(_found.soFar[_found.i]);
    return map;
  }

  UnderlineText get header => _header;

  RiddleState get riddleState => _riddleState;

  set riddleState(RiddleState value) {
    logger.i(value.name);
    if (_riddleState == value || _riddleState == RiddleState.completed) return;
    _riddleState = value;
    switch (_riddleState) {
      case RiddleState.resume:
        {
          _header = ref.read(resumeProvider);
          break;
        }
      case RiddleState.completed:
        {
          _header = UnderlineText("challenge_done_${mockInteger(0, 9)}".tr());
          break;
        }
      default:
        {
          _header = ref.read(welcomeUserProvider);
        }
    }
    notifyListeners();
  }

  Future<void> validate(String text) async {
    if (_lastChance) {
      await _newFound();
      lastChance = false;
    } else {
      bool isValid = focusedWord!.value == text;
      final Hint hint = ref.read(hintProvider(date).notifier);

      if (isValid) {
        hint.state = ref.read(correctAnswerProvider);
        await _newFound();
      } else {
        hint.state = "wrong_${mockInteger(0, 4)}".tr();
        _found = _found.copyWith(lastFound: DateTime.now(), mistake: text);
      }
    }
    notifyListeners();
  }

  Future<void> _newFound() async {
    final DateTime now = DateTime.now();
    _found = _found.copyWith(i: _found.i + 1, lastFound: now, mistake: null);
    logger.i("$_found");
    final bool everyFound = _riddle?.isCompleted(_found.i) ?? false;
    done = everyFound;
  }

  initiateTip() {
    if (_found.soFar.containsKey(_found.i)) {
      final List<String> soFar = List<String>.from(_found.soFar[_found.i]);
      logger.i(_found.soFar.toString());
      _tip = Tip.fromWord(focusedWord!.value, soFar: soFar);
      _updateSoFar(_tip);
    } else {
      _tip = Tip.fromWord(focusedWord!.value);
      _updateSoFar(_tip);
    }

    final List<String> soFar1 = List<String>.from(_found.soFar[_found.i]);
    lastChance = focusedWord!.value.length - 1 == soFar1.length;

    notifyListeners();
  }

  bool get lastChance => _lastChance;

  set lastChance(bool value) {
    if (_lastChance == value) return;
    _lastChance = value;
    if (_lastChance) {
      Future.delayed(
        const Duration(milliseconds: 1500),
        () {
          ref.read(hintProvider(date).notifier).state =
              "skip_next_${mockInteger(0, 9)}".tr();
        },
      );
    }
    notifyListeners();
  }

  _updateSoFar(Tip? tip) {
    if (tip == null) return;
    ref.read(hintProvider(date).notifier).state = _tip!.text;

    Map<int, dynamic> map = Map<int, dynamic>.from(_found.soFar);
    map.update(_found.i, (value) => [...value, tip.t], ifAbsent: () => [tip.t]);
    final DateTime now = DateTime.now();
    _found = _found.copyWith(soFar: map, mistake: null, lastFound: now);
  }

  set done(bool value) {
    _done = value;
    if (!_done) {
      final int i = _found.i;
      final bool containsIndex = _found.soFar.containsKey(i);
      if (containsIndex) {
        final List<String> soFar1 = List<String>.from(_found.soFar[i]);
        lastChance = focusedWord!.value.length - 1 == soFar1.length;
      }
    } else {
      riddleState = RiddleState.completed;
    }
    notifyListeners();
  }
}
