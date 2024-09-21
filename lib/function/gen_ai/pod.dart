import 'dart:developer';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mock_data/mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../enum/pod.dart';
import '../../env/pod.dart';
import '../../model/word.dart';
import '../connectivity/pod.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [GeminiAi])
Future<String> createHint(CreateHintRef ref,
    {required Word word, required String answer}) async {
  final GeminiAi ai = ref.read(geminiAiProvider.notifier);
  return ai.generateHint(word, answer);
}

@Riverpod(keepAlive: true, dependencies: [GeminiAi])
Future<String> helpUser(HelpUserRef ref,
    {required String word, required String mistake}) async {
  final GeminiAi ai = ref.read(geminiAiProvider.notifier);
  return ai.helpUser(word, mistake);
}

@Riverpod(keepAlive: true)
String recallNext(RecallNextRef ref) {
  return [
    "Think of the next word.",
    "Find the next word.",
    "Guess the next word.",
    "Figure out the next word.",
    "Say the next word."
  ][mockInteger(0, 4)];
}

@Riverpod(keepAlive: true, dependencies: [env, appEnv])
class GeminiAi extends _$GeminiAi {
  @override
  GenerativeModel build() {
    final DotEnv dotEnv = ref.read(envProvider);
    final AppEnv appEnv = ref.read(appEnvProvider);
    return GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: dotEnv.get(appEnv == AppEnv.dev ? 'GEMINI_DEV' : 'GEMINI_PROD'),
    );
  }

  FutureOr<String> helpUser(String correct, String mistake) async {
    final List<String> splitter = correct.split(' ');
    final String mistakeWord = mistake.split(' ').last;
    final String prompt =
        'This is puzzle game where user has to find out the second part '
        'of the word. We have given a word "$correct", '
        'where user has to find the second part of the word. '
        'ie., user has to fill the word "${splitter.last}". '
        'But user has entered "$mistakeWord". '
        'First If only typo correction, help the user to correct the spelling. '
        'Then, check if user has entered an invalid word. If yes, ask the user'
        ' do not type something randomly '
        'and help user to use the hint icon. '
        'When you are helping, never mention '
        "about the correct word i.e., ${splitter.last}. "
        'And do not ask questions like "Did you mean by". '
        'Use simple english and also use less than 12 words.';

    log(prompt);
    final List<Content> contents = [Content.text(prompt)];
    return await callResponse(contents);
  }

  FutureOr<String> generateHint(Word word, String ans) async {
    final List<String> splitter = ans.split(' ');
    final String find = splitter.last.toLowerCase();
    final String? replaceQuestion = word.note?.replaceAll('?', find);

    final String? withNote = word.note != null
        ? 'Create a sentence using a phrase $replaceQuestion less than 15 words'
            'Make sure that the word "$find" replace with underscores.'
            'Do not highlight the word. Use simple english'
        /*'Give fill-in-the-blanks question with "$find" as the only '
            'missing word, where user needs to find out in the sentence '
            'Make sure that missing word must completes the phrase "out of ...".'*/
        /*  ? 'This is a Word-Puzzle. Give a fill in the blanks question '
            'which has a words "$replaceQuestion" '
            'where "${splitter.last.toLowerCase()}" is the only dashed word, which user has to find out. '
            'Make sure that question has less than 15 words. Use simple english'
        */ /*? "This is a Word-Puzzle. User need to find out the word $replaceQuestion. "
            'Give me short hint for word "$replaceQuestion" less than 15 words. '
            'Use simple english.'*/
        : null;
    final String prompt =
        'This is a Word-Puzzle. User need to find the word "$ans".'
        'Give me short hint for word "$ans" less than 15 words. '
        'Use simple english.';
    log(word.toString());
    log(withNote ?? "note null");
    log(prompt);
    final List<Content> contents = [Content.text(withNote ?? prompt)];
    return await callResponse(contents);
  }

  FutureOr<String> callResponse(List<Content> contents) => state
          .generateContent(contents)
          .then((value) => value.text ?? "Think")
          .catchError(
        (e, _) {
          if (e is SocketException) {
            ref.read(validateConnectionProvider.notifier).state = -1;
          }
          throw e;
        },
      );
}
