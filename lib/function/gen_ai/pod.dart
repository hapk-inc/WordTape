import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mock_data/mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../env/pod.dart';
import '../connectivity/pod.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true, dependencies: [GeminiAi])
Future<String> createHint(CreateHintRef ref, {required String word}) async {
  final GeminiAi ai = ref.read(geminiAiProvider.notifier);
  return ai.generateHint(word);
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

@Riverpod(keepAlive: true, dependencies: [env])
class GeminiAi extends _$GeminiAi {
  @override
  GenerativeModel build() {
    final DotEnv dotEnv = ref.read(envProvider);
    return GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: kDebugMode ? dotEnv.get('GEMINI_DEV') : "",
    );
  }

  FutureOr<String> helpUser(String correct, String mistake) async {
    final String prompt =
        'This is a Puzzle. User need to enter the word "$correct",'
        'but entered "$mistake". '
        'If only text correction, ask user to correct the word, '
        'Else, ask them to click on Hint icon. '
        "When you're helping, never mention about the correct word i.e., $correct "
        'Use simple english and also use less than 12 words.';
    log(prompt);
    final List<Content> contents = [Content.text(prompt)];
    return await callResponse(contents);
  }

  FutureOr<String> generateHint(String word) async {
    // final List<String> splitter = word.split(' ');
    // debugPrint(splitter.toString());
    final String prompt =
        'This is a Puzzle. User need to find the word "$word".'
        'Give me short hint for word "$word" less than 15 words. '
        'Use simple english. ';
    log(prompt);
    final List<Content> contents = [Content.text(prompt)];
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
