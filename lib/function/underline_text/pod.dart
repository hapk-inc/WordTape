import 'package:easy_localization/easy_localization.dart';
import 'package:mock_data/mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/underline_text.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true)
UnderlineText noRiddle(NoRiddleRef ref) {
  final DateTime now = DateTime.now();
  final List<UnderlineText> noRiddle = List.generate(
    9,
    (index) => UnderlineText("no_riddle_$index".tr()),
  );
  return noRiddle[now.day % noRiddle.length];
}

@Riverpod(keepAlive: true)
UnderlineText welcomeUser(WelcomeUserRef ref) {
  final DateTime now = DateTime.now();
  final List<UnderlineText> welcome = List.generate(
    7,
    (i) => UnderlineText("welcome_$i".tr(), focus: "welcome_${i}_pick".tr()),
  );
  return welcome[now.day % welcome.length];
}

@Riverpod()
UnderlineText resume(ResumeRef ref) {
  final List<UnderlineText> resume = List.generate(
    7,
    (i) => UnderlineText(
      "resume_$i".tr(),
      focus: "complete pattern. sequence.",
    ),
  );
  return resume[mockInteger(0, 6)];
}

@Riverpod(keepAlive: true)
String shareText(ShareTextRef ref) {
  final DateTime now = DateTime.now();
  final List<String> pass = List.generate(7, (index) => "pass_$index".tr());
  return pass[now.day % pass.length];
}

@Riverpod()
String useHighlighter(UseHighlighterRef ref) {
  final List<String> useHighlighter =
      List.generate(5, (index) => "use_highlighter_$index".tr());
  return useHighlighter[mockInteger(0, 4)];
}

@Riverpod()
String correctAnswer(CorrectAnswerRef ref) {
  final List<String> correct = List.generate(8, (i) => "correct_$i".tr());
  return correct[mockInteger(0, 7)];
}

@riverpod
String fillText(FillTextRef ref) {
  final List<String> fillText = List.generate(4, (i) => "fill_text_$i".tr());
  return fillText[mockInteger(0, fillText.length - 1)];
}

@riverpod
String aiError(AiErrorRef ref) {
  final DateTime now = DateTime.now();
  final List<String> onYourOwn =
      List.generate(8, (index) => "think_$index".tr());
  return onYourOwn[now.day % onYourOwn.length];
}

@riverpod
String figureOut(FigureOutRef ref) {
  final DateTime now = DateTime.now();
  final List<String> figureOut = List.generate(7, (i) => "figure_$i".tr());
  return figureOut[now.day % figureOut.length];
}
