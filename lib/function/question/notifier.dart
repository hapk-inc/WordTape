import 'package:easy_localization/easy_localization.dart';

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
  late UnderlineText _header;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Logger _tracker;
  final LocalQuestion _localQuestion = LocalQuestion();
  final LocalFound _localFound = LocalFound();
  late FirestoreQuestion _firestoreQuestion;

  //
  late bool _done = false;
  String _clue = "";

  bool _typing = false;

  QuestionNotifier(this.ref, {required this.date}) {
    final RoutePath path = ref.read(pathNotifierProvider);
    _tracker = ref.read(trackerProvider);
    final bool isDecode = path.path == "/decode";
    if (isDecode) {
      _prompt = Prompt(
        text: UnderlineText(ref.read(figureOutProvider)),
        state: PromptState.search,
      );
    }
    final DateTime now = DateTime.now();
    _isToday = DateUtils.isSameDay(date, now);
    _firestoreQuestion = ref.read(firestoreQuestionProvider);
    _header = const UnderlineText("Thinking for today's puzzle");
  }

  Future questionFound() async {
    //Safe-Initialisation Found

    _found = Found(date: date);

    _question = await _localQuestion.fromDate(date);
    _question ??= await _firestoreQuestion.question(date).then(
      (value) {
        if (value != null) _localQuestion.insert(value);
        return value;
      },
    );

    if (_question == null) return;
    _header = ref.read(welcomeUserProvider);
    final String id = _question!.id!;
    Found? f;
    f = await _localFound.found(id);

    f ??= await _firestoreQuestion.found(id).then(
      (value) {
        if (value != null) _localFound.insert(value);
        return value;
      },
    );
    found = f ?? Found.fromRiddle(_question!);
    _tracker.d(f);
    _prompt = Prompt(
      text: UnderlineText(ref.read(figureOutProvider)),
      state: PromptState.search,
    );

    final int i = _found.i;

    if (_found.untilNow.containsKey(i)) {
      List list = _found.untilNow[i];
      clue = list.last;
    }

    _done = _question!.isCompleted(_found.i);

    if (_done) {
      header = UnderlineText(
        "challenge_done_${mockInteger(0, 6)}".tr(),
        focused: "today. today’s",
      );
      prompt = const Prompt(
        state: PromptState.done,
        text: UnderlineText(
            "You've pieced together the puzzle... but it took teamwork."),
      );
    } else {
      if (_found.i != 1) {
        _header = UnderlineText(
          "resume_${mockInteger(0, 5)}".tr(),
          focused: "sequence. pattern.",
        );
      }
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
            text: UnderlineText(ref.read(figureOutProvider)),
            state: PromptState.search,
          );
          _header = ref.read(welcomeUserProvider);
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
    notifyListeners();
  }

  UnderlineText get header => _header;

  set header(UnderlineText value) {
    _header = value;
    notifyListeners();
  }

  String get clue => _clue;

  set clue(String value) {
    if (_clue == value) return;
    _clue = value;
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

  Word? get focusedWord {
    if (_question == null) return null;
    if (_done) return null;
    return _question?.words[_found.i];
  }

  GlobalKey<FormState> get formKey => _formKey;

  Future<void> validate(String text, {bool revealed = false}) async {
    if (revealed) {
    } else {
      debugPrint("${focusedWord!.value}; Entered $text");
      bool isValid = focusedWord!.value == text;
      if (isValid) {
        await _newFound();
      } else {
        prompt = Prompt(
          text: UnderlineText("wrong_${mockInteger(0, 4)}".tr()),
          state: PromptState.error,
        );
        prompt = _prompt.copyWith(
          text: UnderlineText(
            "use_hint_${mockInteger(0, 7)}".tr(),
            focused: "Hint hint",
          ),
        );
        final DateTime now = DateTime.now();

        found = _found.copyWith(mistake: text, lastFound: now);
      }
    }
  }

  Future<void> _newFound() async {
    prompt = Prompt(
      text: ref.read(foundWordProvider),
      state: PromptState.right,
    );
    final DateTime now = DateTime.now();
    found = _found.copyWith(i: _found.i + 1, mistake: null, lastFound: now);
  }

  List<Word> get searchWord => _question?.searchWord(_found) ?? [];

  set typing(bool value) {
    if (_typing == value) return;
    _typing = value;
    if (!value) ref.read(toastNotifierProvider.notifier).dismiss();
    notifyListeners();
  }

  // String get wordController => _subject.stream.;

  Future<void> helpUser() async {
    typing = true;
    if (_found.untilNow.containsKey(_found.i)) {
      final List<String> list = List.castFrom(_found.untilNow[_found.i]);
      debugPrint(list.toString());
      if (list.isNotEmpty && list.first.isNotEmpty) {
        clue = list[0];
        return;
      }
    }
    clue = "";
    final String answer = _question!.answer(_found);
    clue = await ref
        .read(createHintProvider(focusedWord!, answer).future)
        .catchError(
      (error, stackTrace) {
        _tracker.e("Clue error", error: error);
        if (focusedWord?.hint != null) return focusedWord?.hint ?? "";
        return "";
      },
    );
    if (clue.isEmpty) {
      clue = "think_${mockInteger(0, 7)}".tr();
      return;
    }

    Map<int, dynamic> map = Map<int, dynamic>.from(_found.untilNow);
    map.update(
      _found.i,
      (value) {
        if (value is List) {
          return [...value, if (!value.contains(_clue)) _clue];
        }
      },
      ifAbsent: () => [_clue],
    );
    found = _found.copyWith(untilNow: map);
  }

  Future<void> insert() async => await Future.wait(
        [_localFound.insert(found), _firestoreQuestion.setFound(found)],
      );
}
