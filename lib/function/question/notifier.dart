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
import '../../model/underline_text.dart';
import '../../model/word.dart';
import '../analytics/pod.dart';
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

// const Duration _m2400 = Duration(milliseconds: 2400);

class QuestionNotifier extends ChangeNotifier {
  final Ref<QuestionNotifier> ref;
  final DateTime date;
  Question? _question;
  late Found _found;

  late bool _isTodayOrBefore;
  late Prompt _prompt;
  late UnderlineText _headline;
  Prompt? _mistakePrompt;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Logger _tracker;
  final LocalQuestion _localQuestion = LocalQuestion();
  final LocalFound _localFound = LocalFound();

  //
  late bool _done = false;
  String? _toastText;

  QuestionNotifier(this.ref, {required this.date}) {
    _tracker = ref.read(trackerProvider);

    final UnderlineText figureText = ref.read(figureOutProvider);
    _prompt = Prompt(text: figureText, state: PromptState.search);

    final DateTime now = DateTime.now();
    _isTodayOrBefore =
        DateUtils.isSameDay(date, now) ? true : date.isBefore(now);
    final String str = ref.read(nextPuzzleThinkingProvider);
    _headline = UnderlineText(str, focused: "today’s");
  }

  FirestoreQuestion get _firestoreQuestion =>
      ref.read(firestoreQuestionProvider);

  Future questionFound() async {
    _tracker.i("Safe-Initialisation $date");
    if (!_isTodayOrBefore) {
      final UnderlineText text = ref.read(waitUntilDayComesProvider);
      prompt = Prompt(text: text, state: PromptState.done);
      return;
    }

    _found = Found(date: date); //Safe-Initialisation Found

    _question = await _localQuestion.fromDate(date);
    _question ??= await _firestoreQuestion.question(date).then(
      (value) {
        if (value != null) _localQuestion.insert(value);
        return value;
      },
    );

    if (_question == null) return;

    if (_isTodayOrBefore) _headline = ref.read(welcomeUserProvider);

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
    final UnderlineText text = ref.read(figureOutProvider);
    _prompt = Prompt(text: text, state: PromptState.search);

    if (_found.i != 1 && _isTodayOrBefore) _headline = ref.read(resumeProvider);

    _done = _question!.isCompleted(_found.i);

    if (_done) {
      final UnderlineText text = ref.read(questionCrackedProvider);
      _headline = text;
      _prompt = Prompt(text: text, state: PromptState.done);
      ref.read(
        questionCompletedProvider(
          i: _question?.i ?? 0,
          dateTime: _found.lastFound ?? DateTime.now(),
        ),
      );
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
          final UnderlineText text = ref.read(figureOutProvider);
          _prompt = Prompt(text: text, state: PromptState.search);
          _headline = ref.read(welcomeUserProvider);
        }
        notifyListeners();
      },
    );
    super.addListener(listener);
  }

  //////////////////////////GET FUNCTION

  Question? get question => _question;

  String? get toastText => _toastText;

  Found get found {
    if (_question == null) return Found(date: date);
    return _found;
  }

  set found(Found value) {
    final Found f = value.copyWith(lastFound: DateTime.now());
    if (_found.lastFound == null) _firestoreQuestion.firstFound(f.id);
    _found = f;
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

  Prompt get prompt => _prompt;

  set prompt(Prompt value) {
    if (_prompt == value) return;
    if (_prompt.delay) {
      Future.delayed(Duration(milliseconds: 1500), () {
        _prompt = value;
        notifyListeners();
      });
    } else {
      _prompt = value;
      notifyListeners();
    }
    //_prompt = value;
    /*if (_prompt.state == value.state) {
      if (_prompt.state == PromptState.error) {
        Future.delayed(
          Duration(milliseconds: 1500),
          () {
            _prompt = value;
            notifyListeners();
          },
        );
      }
    } else {
      _prompt = value;
    }*/
    // notifyListeners();
  }

  bool get isWinner => found.untilNow.isEmpty;

  Word? get focusedWord {
    if (_question == null) return null;
    if (_done) return null;
    return _question?.words[_found.i];
  }

  GlobalKey<FormState> get formKey => _formKey;

  Future<bool> validate(String text, {bool revealed = false}) async {
    ref.read(toastNotifierProvider.notifier).closingIfOpen();
    bool isValid = false;
    if (revealed) {
    } else {
      isValid = focusedWord!.value == text;
      found = _found;
      if (isValid) {
        _toastText = null;
        await _newFound();
      } else {
        prompt = Prompt(
          text: UnderlineText(
            "wrong_${mockInteger(0, 4)}".tr(),
            focused: "answer",
          ),
          state: PromptState.error,
        );
        if (_mistakePrompt != null) prompt = _mistakePrompt!;
        final int random2 = mockInteger(0, 7);
        prompt = _prompt.copyWith(
          text: UnderlineText("use_hint_$random2".tr(), focused: "Hint hint"),
        );

        found = _found.copyWith(mistake: text);
      }
    }
    return isValid;
  }

  Future<void> _newFound() async {
    final UnderlineText underlineText = ref.read(foundWordProvider);
    prompt = Prompt(text: underlineText, state: PromptState.right);
    found = _found.copyWith(i: _found.i + 1, mistake: null);
  }

  List<Word> get searchWord => _question?.searchWord(_found) ?? [];

  Future<void> helpUser() async {
    List<String>? hints = _question?.words[_found.i].hints;
    if (focusedWord == null) return;
    if (hints == null || _question?.words[_found.i].note != null) {
      toastText = await ref.watch(generateToastProvider(
        focusedWord!,
        _question!.answer(_found),
      ).future);
      if (_toastText != null) saveToast(_toastText!);
    } else {
      final int index =
          hints.length == 1 ? 0 : mockInteger(0, hints.length - 1);
      toastText = hints[index];
      final String saveIndex = "#$index";
      saveToast(saveIndex);
    }
  }

  void saveToast(String str) {
    Map<int, dynamic> map = Map<int, dynamic>.from(_found.untilNow);
    map.update(
      _found.i,
      (value) {
        if (value is List) return [...value, if (!value.contains(str)) str];
      },
      ifAbsent: () => [str],
    );
    found = _found.copyWith(untilNow: map);
  }

  set toastText(String? value) {
    if (_toastText == value) return;
    _toastText = value;
    notifyListeners();
  }

  Future<void> insert() async => await Future.wait(
        [
          _localFound.insert(_found),
          _firestoreQuestion.setFound(_found),
        ],
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

  Future<void> validateIfWrong(String value) async {
    if (focusedWord?.value != value) {
      final bool typoCorrection = await ref.watch(typoCorrectionProvider(
        focusedWord!,
        value.toUpperCase(),
      ).future);

      if (typoCorrection) {
        mistakePrompt = Prompt(
          text: UnderlineText("Check your spelling"),
          state: PromptState.error,
          delay: true,
        );
      } else {
        final bool checkValidWord = await ref.watch(checkIfValidWordProvider(
          question!.typed(found, value),
        ).future);
        if (checkValidWord) {
          debugPrint("It's valid word but not correct answer");
          mistakePrompt = Prompt(
            text: ref.read(validWordCorrectionProvider),
            state: PromptState.error,
            delay: true,
          );
        } else {
          mistakePrompt = null;
        }
      }
    }
    notifyListeners();
  }

  set mistakePrompt(Prompt? value) {
    if (_mistakePrompt == value) return;
    _mistakePrompt = value;
    notifyListeners();
  }
}
