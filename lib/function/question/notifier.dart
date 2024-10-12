import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mock_data/mock_data.dart';

import '../../enum/enum.dart';
import '../../logger/log.dart';
import '../../model/player.dart';
import '../../model/tip.dart';
import '../../model/underline_text.dart';
import '../../model/found.dart';
import '../../model/question.dart';
import '../../model/word.dart';

//
import '../firestore/pod.dart';
import '../local/pod.dart';
import '../underline_text/pod.dart';
import 'hint.dart';

const String backspace = "🔙";
const String done = "✔️";

final ChangeNotifierProviderFamily<QuestionNotifier, DateTime>
    questionNotifierProvider =
    ChangeNotifierProvider.family<QuestionNotifier, DateTime>(
  (ref, date) => QuestionNotifier(ref, date: date)..init(),
);

class QuestionNotifier extends ChangeNotifier {
  final Ref<QuestionNotifier> ref;
  final DateTime date;
  Question? _riddle;
  late Found _found;
  late Logger _logger;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Tip? _tip;
  late bool _done = false;
  late UnderlineText _header = const UnderlineText("Hi");
  bool _lastChance = false;
  late RiddleState _riddleState = RiddleState.launch;
  late PromptState _promptState = PromptState.search;

  QuestionNotifier(this.ref, {required this.date}) {
    _logger = ref.read(logProvider);
    final Player? player = ref.read(playerProvider).value;
    if (player != null) {
      final String n = "${player.nickName}";
      _header = UnderlineText("Hi $n", focus: n);
    }

    _found = Found(date: date);
  }

  Future init() async {
    _riddle = await ref.watch(questionWithDateProvider(date: date).future);

    if (_riddle != null) {
      _header = ref.read(welcomeUserProvider);
      final foundArg = localFoundArgIdProvider(id: _riddle!.id);
      _found = await ref.watch(foundArg.future) ?? Found.fromRiddle(_riddle!);
    }
    // done = _found.i == 6;
    done = _riddle?.isCompleted(_found.i) ?? false;
    if (!_done) {
      riddleState = _found.i == 1 ? RiddleState.launch : RiddleState.resume;
      if (_found.untilNow.containsKey(_found.i)) {
        final List<String> untilNow1 =
            List<String>.from(_found.untilNow[_found.i]);
        lastChance = focusedWord!.value.length - 1 == untilNow1.length;
      }
      // notifyListeners();
    }
  }

  @override
  void addListener(VoidCallback listener) {
    ref.listen<Question?>(
      onQuestionModifiedProvider(date: date).select((value) => value.value),
      (previous, next) {
        _logger.i("riddleDocProvider $next");
        if (next != null) riddle = next;
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

  Question? get riddle => _riddle;

  set riddle(Question? value) {
    if (_riddle == value || value == null) return;
    _riddle = value;
    notifyListeners();
  }

  Tip? get tip => _tip;

  PromptState get promptState => _promptState;

  set promptState(PromptState value) {
    if (_promptState == value) return;
    _promptState = value;
    notifyListeners();
  }

  bool compareHighlighter(String? value) {
    if (value == null) return false;
    final List<String> splitter = value.split("");
    Map<int, dynamic> map = _found.untilNow;
    if (!map.containsKey(_found.i)) return true;
    final List<String> untilNow = List<String>.from(_found.untilNow[_found.i]);
    return untilNow.every((char) => splitter.contains(char));
  }

  List<String> get highlightedChar {
    if (!_found.untilNow.containsKey(_found.i)) return [];
    List<String> map = List.from(_found.untilNow[_found.i]);
    return map;
  }

  UnderlineText get header => _header;

  RiddleState get riddleState => _riddleState;

  set riddleState(RiddleState value) {
    _logger.i(value.name);
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
          _header = UnderlineText(
            "challenge_done_${mockInteger(0, 9)}".tr(),
            focus: "challenge. challenge",
          );
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
    _logger.i("$_found");
    final bool everyFound = _riddle?.isCompleted(_found.i) ?? false;
    done = everyFound;
    if (done) {
      ref.read(firestoreQuestionProvider).fetchFound(_found);
      ref.read(firestoreUserProvider).userFound(found);
    }
  }

  initiateTip() {
    if (_found.untilNow.containsKey(_found.i)) {
      final List<String> untilNow =
          List<String>.from(_found.untilNow[_found.i]);
      _logger.i(_found.untilNow.toString());
      _tip = Tip.fromWord(focusedWord!.value, untilNow: untilNow);
      _updateuntilNow(_tip);
    } else {
      _tip = Tip.fromWord(focusedWord!.value);
      _updateuntilNow(_tip);
    }

    final List<String> untilNow1 = List<String>.from(_found.untilNow[_found.i]);
    lastChance = focusedWord!.value.length - 1 == untilNow1.length;

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

  _updateuntilNow(Tip? tip) {
    if (tip == null) return;
    promptState = PromptState.tip;
    ref.read(hintProvider(date).notifier).state = _tip!.text;

    Map<int, dynamic> map = Map<int, dynamic>.from(_found.untilNow);
    map.update(_found.i, (value) => [...value, tip.t], ifAbsent: () => [tip.t]);
    final DateTime now = DateTime.now();
    _found = _found.copyWith(untilNow: map, mistake: null, lastFound: now);
  }

  set done(bool value) {
    _done = value;
    if (!_done) {
      final int i = _found.i;
      final bool containsIndex = _found.untilNow.containsKey(i);
      if (containsIndex) {
        final List<String> untilNow1 = List<String>.from(_found.untilNow[i]);
        lastChance = focusedWord!.value.length - 1 == untilNow1.length;
      }
    } else {
      ref.read(hintProvider(date).notifier).state =
          "decoded_${mockInteger(0, 7)}".tr();
      riddleState = RiddleState.completed;
    }
    notifyListeners();
  }
}
