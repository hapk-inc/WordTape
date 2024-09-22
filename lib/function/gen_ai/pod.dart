import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mock_data/mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../enum/pod.dart';
import '../../env/pod.dart';
import '../../model/tip.dart';
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

@Riverpod(dependencies: [GeminiAi])
Future<Tip?> generateTip(GenerateTipRef ref,
    {required String str, List<String> soFar = const []}) async {
  final GeminiAi ai = ref.read(geminiAiProvider.notifier);
  return ai.generateTip(str, soFar);
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
        : null;
    final String prompt =
        'This is a Word-Puzzle. User need to find the word "$ans".'
        'Give me short hint for word "$ans" less than 15 words. '
        'Use simple english.';

    log(withNote ?? prompt);
    final List<Content> contents = [Content.text(withNote ?? prompt)];
    return await callResponse(contents);
  }

  FutureOr<String> callResponse(List<Content> contents) => state
          .generateContent(contents)
          .then((value) => value.text ?? "Think")
          .catchError(
        (e, _) {
          print(e);
          if (e is SocketException) {
            ref.read(validateConnectionProvider.notifier).state = -1;
          }
          throw e;
        },
      );

  FutureOr<Tip?> generateTip(String str, List<String> soFar) async {
    final String prompt =
        "This is a word puzzle, and the user has to find the word '$str'."
        " Please provide one character randomly from that word"
        " (except for the first letter)."
        " ${soFar.isNotEmpty ? "Already revealed words are $soFar" : ""}"
        " I have a class model called 'Tip,' which contains a variable 't'"
        " that holds one character,"
        //"'position' int variable"
        //" for position of the letter (from left to right)"
        " and another variable 'text' that indicates the which letter is there"
        " you are providing along with the letter itself in one line."
        " Do not highlight it or enclose it in any format."
        " Please give this in toJson() format in one line so I can decode it"
        " and convert it to my class model.";
    log(prompt);
    final List<Content> contents = [Content.text(prompt)];
    final String x = await callResponse(contents);
    log(x);

    int start = x.indexOf('{');
    int end = x.indexOf('}', start);

    if (start != -1 && end != -1) {
      String result = x.substring(start, end + 1);
      final map = jsonDecode(result);
      return Tip.fromJson(map);
    } else {
      return null;
    }
  }
}
