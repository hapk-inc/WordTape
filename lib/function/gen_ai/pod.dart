import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wordtape/function/underline_text/pod.dart';

import '../../enum/enum.dart';
import '../../firebase/pod.dart';
import '../../model/word.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [GeminiAi])
Future<String> createHint(CreateHintRef ref, Word word, String answer) async {
  final GeminiAi ai = ref.read(geminiAiProvider.notifier);
  return ai.createHint(word, answer);
}

@Riverpod(keepAlive: true, dependencies: [GeminiAi])
Future<String> helpUser(HelpUserRef ref, String correct, String mistake) async {
  final GeminiAi ai = ref.read(geminiAiProvider.notifier);
  return ai.helpUser(correct, mistake);
}

@Riverpod(keepAlive: true, dependencies: [env, appEnv])
class GeminiAi extends _$GeminiAi {
  @override
  GenerativeModel build() {
    final DotEnv dotEnv = ref.watch(envProvider);
    final AppEnv appEnv = ref.watch(appEnvProvider);
    String api;

    api = dotEnv.get(appEnv == AppEnv.dev ? 'GEMINI_DEV' : 'GEMINI_PROD');

    return GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: api);
  }

  FutureOr<String> helpUser(String correct, String mistake) async {
    final List<String> splitter = correct.split(' ');
    final String mistakeWord = mistake.split(' ').last;
    final String prompt = replaceHash("help_user".tr(), [
      capitalize(correct),
      splitter.last,
      mistakeWord,
      splitter.last,
    ]);
    log(prompt);
    final List<Content> contents = [Content.text(prompt)];
    return await callResponse(contents);
  }

  FutureOr<String> createHint(Word word, String answer) async {
    final List<String> splitter = answer.split(' ');
    final String find = splitter.last.toLowerCase();
    final String? replaceQuestion = word.note?.replaceAll('?', find);
    log("with_note".tr());
    String? withNote;
    String prompt;
    if (word.note != null) {
      withNote = replaceHash("with_note".tr(), [replaceQuestion ?? "", find]);
    }
    prompt = replaceHash("hint".tr(), [
      capitalize(answer),
      capitalize(answer),
      find,
    ]);
    log(withNote ?? prompt);
    final List<Content> contents = [Content.text(withNote ?? prompt)];
    return await callResponse(contents);
  }

  FutureOr<String> callResponse(List<Content> contents) => state
          .generateContent(contents)
          .then((value) => value.text ?? ref.read(aiErrorProvider))
          .catchError(
        (e, _) {
          if (e is SocketException) {
            // ref.read(validateConnectionProvider.notifier).state = -1;
          }
          throw e;
        },
      );

  String replaceHash(String input, List<String> replace) {
    List<String> parts = input.split('#');
    List<String> r = [];

    for (int i = 0; i < parts.length; i++) {
      r.add(parts[i]);
      if (i < replace.length) r.add(replace[i]);
    }
    return r.join('');
  }

  String capitalize(String str) => toBeginningOfSentenceCase(str) ?? "";
}
