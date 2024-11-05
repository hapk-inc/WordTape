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
    7,
    (i) => UnderlineText(
      "resume_$i".tr(),
      focused: "complete pattern. sequence.",
    ),
  );
  return resume[mockInteger(0, 6)];
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
String fillText(Ref ref) {
  final List<String> fillText = List.generate(4, (i) => "fill_text_$i".tr());
  return fillText[mockInteger(0, fillText.length - 1)];
}

@riverpod
String aiError(Ref ref) {
  final DateTime now = DateTime.now();
  final List<String> onYourOwn = List.generate(8, (i) => "think_$i".tr());
  return onYourOwn[now.day % onYourOwn.length];
}

@riverpod
String figureOut(Ref ref) {
  final DateTime now = DateTime.now();
  final List<String> figureOut = List.generate(7, (i) => "figure_$i".tr());
  return figureOut[now.day % figureOut.length];
}

@riverpod
UnderlineText cookieInfo(Ref ref) {
  final Map map = jsonDecode("cookies".tr());
  final List list = map["cookies"];
  final List<UnderlineText> cookieInfo = List.from(
    list.map(
      (e) {
        final Map<String, dynamic> json = Map<String, dynamic>.from(e);
        return UnderlineText.fromJson(json);
      },
    ),
  );
  return cookieInfo[mockInteger(0, list.length - 1)];
}

@Riverpod(keepAlive: true)
UnderlineText notifyText(Ref ref) {
  final Map map = jsonDecode("notify".tr());
  final List list = map["notify"];
  final List<UnderlineText> notify = List.from(
    list.map(
      (e) {
        final Map<String, dynamic> json = Map<String, dynamic>.from(e);
        return UnderlineText.fromJson(json);
      },
    ),
  );
  return notify[mockInteger(0, list.length - 1)];
}

@Riverpod(keepAlive: true)
UnderlineText welcomeUser(Ref ref) {
  final Map map = jsonDecode("welcome".tr());
  final List list = map["welcome"];
  final List<UnderlineText> welcome = List.from(
    list.map(
      (e) {
        final Map<String, dynamic> json = Map<String, dynamic>.from(e);
        return UnderlineText.fromJson(json);
      },
    ),
  );
  final DateTime now = DateTime.now();
  return welcome[now.day % welcome.length];
}

@riverpod
UnderlineText foundWord(Ref ref) {
  final Map map = jsonDecode("correct_text".tr());
  final List list = map["correct"];
  final List<UnderlineText> foundWord = List.from(
    list.map(
      (e) {
        final Map<String, dynamic> json = Map<String, dynamic>.from(e);
        return UnderlineText.fromJson(json);
      },
    ),
  );
  return foundWord[mockInteger(0, foundWord.length - 1)];
}

@riverpod
List<UnderlineText> howPlay(Ref ref) {
  final List list = jsonDecode("how_to_play".tr());
  return List.from(
    list.map(
      (e) {
        final Map<String, dynamic> json = Map<String, dynamic>.from(e);
        return UnderlineText.fromJson(json);
      },
    ),
  );
}
