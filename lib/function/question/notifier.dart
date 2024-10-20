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
import '../firestore/pod.dart';
import '../firestore/question.dart';
import '../local/found.dart';
import '../local/question.dart';
import '../underline_text/pod.dart';

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
  // late Tip _tip;

  //
  late UnderlineText _header;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Logger logger = Logger();
  final LocalQuestion _localQuestion = LocalQuestion();
  final LocalFound _localFound = LocalFound();
  late FirestoreQuestion _firestoreQuestion;

  //
  late bool _done = false;

  QuestionNotifier(this.ref, {required this.date}) {
    //final Player? player = ref.read(playerProvider).value;
    final DateTime now = DateTime.now();
    _isToday = DateUtils.isSameDay(date, now);
    _firestoreQuestion = ref.read(firestoreQuestionProvider);
    _header = const UnderlineText("Thinking for today's puzzle");
  }

  Future questionFound() async {
    // final Player? player = await ref.read(playerProvider.future);

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
    _found = f ?? Found.fromRiddle(_question!);
    _done = _question!.isCompleted(_found.i);
    debugPrint("75==$_found");

    _prompt = Prompt(
      text: UnderlineText(ref.read(figureOutProvider)),
      state: PromptState.search,
    );

    notifyListeners();
  }

  //////////////////////////GET FUNCTION

  Question? get question => _question;

  Found get found {
    if (_question == null) return Found(date: date);
    return _found;
  }

  set found(Found value) {
    if (_found == value) return;
    _found = value;

    if (kIsWeb) {
      ref.read(firestoreQuestionProvider).setFound(_found);
    } else {
      _localFound.insert(_found);
    }
    notifyListeners();
  }

  bool get done => _done;

  UnderlineText get header => _header;

  Prompt get prompt => _prompt;

  set prompt(Prompt value) {
    if (_prompt == value) return;
    if (_prompt.state == value.state) {
      Future.delayed(
        _m2400,
        () {
          _prompt = value;
          notifyListeners();
        },
      );
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
          state: PromptState.wrong,
        );
        final DateTime now = DateTime.now();

        found = _found.copyWith(mistake: text, lastFound: now);
      }
    }
  }

  Future<void> _newFound() async {
    final DateTime now = DateTime.now();
    found = _found.copyWith(i: _found.i + 1, mistake: null, lastFound: now);
    debugPrint("$_found");
    final bool everyFound = _question?.isCompleted(_found.i) ?? false;
    _done = everyFound;
    if (_done) {
      ref.read(firestoreQuestionProvider).setFound(_found);
      ref.read(firestoreUserProvider).userFound(_found);
    }
  }

  List<Word> get searchWord => _question?.searchWord(_found) ?? [];

  createClue() {}
}
