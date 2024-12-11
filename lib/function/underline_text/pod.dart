import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mock_data/mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/underline_text.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true)
UnderlineText noQuestion(Ref ref) {
  final DateTime now = DateTime.now();
  final List<UnderlineText> list = List.generate(
    9,
    (index) => UnderlineText("no_riddle_$index".tr()),
  );
  return list[now.day % list.length];
}

@Riverpod(keepAlive: true)
UnderlineText resume(Ref ref) {
  final List<UnderlineText> resume = List.generate(
    6,
    (i) => UnderlineText(
      "resume_$i".tr(),
      focused: "complete pattern. sequence.",
    ),
  );
  return resume[mockInteger(0, 5)];
}

@Riverpod(keepAlive: true)
String logoutText(Ref ref) => "logout_${DateTime.now().day % 10}".tr();

@Riverpod(keepAlive: true)
String inProgress(Ref ref) {
  final DateTime now = DateTime.now();
  final List<String> progress = List.generate(3, (i) => "progress_$i".tr());
  return progress[now.day % progress.length];
}

@Riverpod()
String useHighlighter(Ref ref) {
  final List<String> useHighlighter = List.generate(
    5,
    (i) => "use_highlighter_$i".tr(),
  );
  return useHighlighter[mockInteger(0, 4)];
}

@riverpod
UnderlineText fillText(Ref ref) {
  final List<String> fillText = List.generate(4, (i) => "fill_text_$i".tr());
  return UnderlineText(
    fillText[mockInteger(0, fillText.length - 1)],
    focused: 'text content',
  );
}

@Riverpod(keepAlive: true)
String pressStart(Ref ref) => "press_start_${mockInteger(0, 3)}".tr();

@riverpod
String aiError(Ref ref) {
  final DateTime now = DateTime.now();
  final List<String> onYourOwn = List.generate(8, (i) => "think_$i".tr());
  return onYourOwn[now.day % onYourOwn.length];
}

@riverpod
String nextPuzzleThinking(Ref ref) {
  final DateTime now = DateTime.now();
  final List<String> next = List.generate(5, (i) => "next_puzzle_$i".tr());
  return next[now.day % next.length];
}

@riverpod
UnderlineText figureOut(Ref ref) {
  final DateTime now = DateTime.now();
  final List<String> figureOut = List.generate(7, (i) => "figure_$i".tr());
  return UnderlineText(figureOut[now.day % figureOut.length], focused: 'word');
}

@riverpod
UnderlineText cookieInfo(Ref ref) {
  final Map map = jsonDecode("cookies".tr());
  final List list = map["cookies"];
  final List<UnderlineText> cookieInfo = _conversion(list);
  return cookieInfo[mockInteger(0, list.length - 1)];
}

@Riverpod(keepAlive: true)
UnderlineText notifyText(Ref ref) {
  final Map map = jsonDecode("notify".tr());
  final List list = map["notify"];
  final List<UnderlineText> notify = _conversion(list);
  return notify[mockInteger(0, list.length - 1)];
}

@Riverpod(keepAlive: true)
UnderlineText welcomeUser(Ref ref) {
  final Map map = jsonDecode("welcome".tr());
  final List list = map["welcome"];
  final List<UnderlineText> welcome = _conversion(list);
  final DateTime now = DateTime.now();
  return welcome[now.day % welcome.length];
}

@riverpod
UnderlineText foundWord(Ref ref) {
  final Map map = jsonDecode("correct_text".tr());
  final List list = map["correct"];
  final List<UnderlineText> foundWord = _conversion(list);
  return foundWord[mockInteger(0, foundWord.length - 1)];
}

@riverpod
List<UnderlineText> howPlay(Ref ref) {
  final List list = jsonDecode("how_to_play".tr());
  return _conversion(list);
}

@Riverpod()
UnderlineText questionCracked(Ref ref) {
  final Map map = jsonDecode("question_cracked".tr());
  final List list = jsonDecode(map["question_cracked"]);
  return _conversion(list).elementAt(mockInteger(0, list.length - 1));
}

@Riverpod()
UnderlineText waitUntilDayComes(Ref ref) {
  final Map map = jsonDecode("wait_until_day_comes".tr());
  final List list = map["wait_until_day_comes"];
  return _conversion(list).elementAt(mockInteger(0, list.length - 1));
}

List<UnderlineText> _conversion(List list) => List.from(
      list.map(
        (e) {
          final Map<String, dynamic> json = Map<String, dynamic>.from(e);
          return UnderlineText.fromJson(json);
        },
      ),
    );
