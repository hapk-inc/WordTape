import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mock_data/mock_data.dart';

import '../../enum/enum.dart';
import '../../model/found.dart';
import '../../model/prompt.dart';
import '../../model/question.dart';
import '../../model/route_path.dart';
import '../../model/underline_text.dart';
import '../../model/word.dart';
import '../../router/path.dart';
import '../firestore/pod.dart';
import '../firestore/question.dart';
import '../gen_ai/pod.dart';
import '../local/found.dart';
import '../local/question.dart';
import '../underline_text/pod.dart';
import 'toast.dart';

final ChangeNotifierProviderFamily<QuestionNotifier, DateTime>
    questionNotifierProvider =
    ChangeNotifierProvider.family<QuestionNotifier, DateTime>(
  (ref, date) => QuestionNotifier(ref, date: date)..questionFound(),
);

const Duration _m2400 = Duration(milliseconds: 2400);

class QuestionNotifier extends ChangeNotifier {
  final Ref<QuestionNotifier> ref;
  final DateTime date;
  Question? _question;
  late Found _found;

  late bool _isToday;
  late Prompt _prompt;
  late UnderlineText _headline;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Logger _tracker;
  final LocalQuestion _localQuestion = LocalQuestion();
  final LocalFound _localFound = LocalFound();
  // late FirestoreQuestion _firestoreQuestion;

  //
  late bool _done = false;
  String _riddleClue = "";

  bool _typing = false;

  QuestionNotifier(this.ref, {required this.date}) {
    final RoutePath path = ref.read(pathNotifierProvider);
    _tracker = ref.read(trackerProvider);
    final bool isDecode = path.path == "/decode";
    if (isDecode) {
      _prompt = Prompt(
        text: ref.read(figureOutProvider),
        state: PromptState.search,
      );
    }
    final DateTime now = DateTime.now();
    _isToday = DateUtils.isSameDay(date, now);
    final String str = ref.read(nextPuzzleThinkingProvider);
    _headline = UnderlineText(str, focused: "today’s");
  }

  FirestoreQuestion get _firestoreQuestion =>
      ref.read(firestoreQuestionProvider);

  Future questionFound() async {
    _found = Found(date: date); //Safe-Initialisation Found

    _question = await _localQuestion.fromDate(date);
    _question ??= await _firestoreQuestion.question(date).then(
      (value) {
        if (value != null) _localQuestion.insert(value);
        return value;
      },
    );

    if (_question == null) return;

    if (_isToday) _headline = ref.read(welcomeUserProvider);

    final String id = _question!.id!;
    Found? f;

    if (!kIsWeb) f = await _localFound.found(id);

    f ??= await _firestoreQuestion.found(id).then(
      (value) {
        if (value != null) _localFound.insert(value);
        return value;
      },
    );

    _found = f ?? Found.fromRiddle(_question!);
    _tracker.d(f);
    final UnderlineText text = ref.read(figureOutProvider);
    _prompt = Prompt(text: text, state: PromptState.search);

    if (_found.i != 1 && _isToday) _headline = ref.read(resumeProvider);

    if (_found.untilNow.containsKey(_found.i)) {
      List l = _found.untilNow[_found.i];
      _riddleClue = l.last;
    }

    _done = _question!.isCompleted(_found.i);

    if (_done) {
      final UnderlineText text = ref.read(questionCrackedProvider);
      _prompt = Prompt(text: text, state: PromptState.done);
      _headline = text;
    }

    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    ref.listen<Question?>(
      onQuestionModifiedProvider(date: date).select((value) => value.value),
      (_, next) {
        if (next != null) {
          _question = next;
          _prompt = Prompt(
            text: ref.read(figureOutProvider),
            state: PromptState.search,
          );
          _headline = ref.read(welcomeUserProvider);
        }
        notifyListeners();
      },
    );
    super.addListener(listener);
  }

  //////////////////////////GET FUNCTION

  Question? get question => _question;

  Found get found {
    if (_question == null) return Found(date: date);
    return _found;
  }

  set found(Found value) {
    if (_found.i == 1 && value.i == 2) _firestoreQuestion.firstFound(value.id);
    _found = value;
    done = question!.isCompleted(_found.i);
    insert();
    notifyListeners();
  }

  bool get done => _done;

  set done(bool value) {
    if (_done == value) return;
    _done = value;
    final UnderlineText text = ref.read(questionCrackedProvider);
    prompt = Prompt(text: text, state: PromptState.done);
    if (_found.untilNow.isEmpty) _firestoreQuestion.winPlayed(_found.id);
    notifyListeners();
  }

  UnderlineText get headline => _headline;

  set headline(UnderlineText value) {
    _headline = value;
    notifyListeners();
  }

  String get riddleClue => _riddleClue;

  set riddleClue(String value) {
    if (_riddleClue == value) return;
    _riddleClue = value;
    notifyListeners();
  }

  Prompt get prompt => _prompt;

  set prompt(Prompt value) {
    if (_prompt == value) return;
    if (_prompt.state == value.state) {
      if (_prompt.state == PromptState.error) {
        Future.delayed(
          _m2400,
          () {
            _prompt = value;
            notifyListeners();
          },
        );
      }
    } else {
      _prompt = value;
    }
    notifyListeners();
  }

  bool get isWinner => found.untilNow.isEmpty;

  Word? get focusedWord {
    if (_question == null) return null;
    if (_done) return null;
    return _question?.words[_found.i];
  }

  GlobalKey<FormState> get formKey => _formKey;

  Future<void> validate(String text, {bool revealed = false}) async {
    if (revealed) {
    } else {
      bool isValid = focusedWord!.value == text;
      final DateTime now = DateTime.now();
      found = _found.copyWith(lastFound: now);
      if (isValid) {
        await _newFound();
      } else {
        prompt = Prompt(
          text: UnderlineText(
            "wrong_${mockInteger(0, 4)}".tr(),
            focused: "answer",
          ),
          state: PromptState.error,
        );
        final int random2 = mockInteger(0, 7);
        prompt = _prompt.copyWith(
          text: UnderlineText("use_hint_$random2".tr(), focused: "Hint hint"),
        );

        found = _found.copyWith(mistake: text);
      }
    }
  }

  Future<void> _newFound() async {
    final UnderlineText underlineText = ref.read(foundWordProvider);
    prompt = Prompt(text: underlineText, state: PromptState.right);
    found = _found.copyWith(i: _found.i + 1, mistake: null);
  }

  List<Word> get searchWord => _question?.searchWord(_found) ?? [];

  set typing(bool value) {
    if (_typing == value) return;
    _typing = value;
    if (!value) ref.read(toastNotifierProvider.notifier).dismiss();
    notifyListeners();
  }

  Future<void> helpUser() async {
    typing = true;
    if (_found.untilNow.containsKey(_found.i)) {
      final List<String> clues = List.castFrom(_found.untilNow[_found.i]);

      if (clues.isNotEmpty && clues.first.isNotEmpty) {
        riddleClue = clues.first;
        return;
      }
    }
    riddleClue = "";
    final String answer = _question!.answer(_found);
    riddleClue = await ref
        .read(createHintProvider(focusedWord!, answer).future)
        .catchError(
      (error, stackTrace) {
        _tracker.e("Clue error", error: error);
        if (focusedWord?.hint != null) return focusedWord?.hint ?? "";
        return "";
      },
    );
    if (riddleClue.isEmpty) {
      riddleClue = ref.read(aiErrorProvider);
      return;
    }

    Map<int, dynamic> map = Map<int, dynamic>.from(_found.untilNow);
    map.update(
      _found.i,
      (value) {
        if (value is List) {
          return [...value, if (!value.contains(_riddleClue)) _riddleClue];
        }
      },
      ifAbsent: () => [_riddleClue],
    );
    found = _found.copyWith(untilNow: map);
  }

  Future<void> insert() async => await Future.wait(
        [_localFound.insert(found), _firestoreQuestion.setFound(found)],
      );

  List<String> get summary {
    if (found.i != 1) {
      final List<String> list = [
        for (int i = 0; i <= found.i - 1; i++)
          found.untilNow.containsKey(i) ? "🟧" : "🟩",
      ];
      return list;
    }
    return [];
  }
}
