import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mock_data/mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dot_env.dart';
import 'puzzle/puzzle_notifier.dart';

part 'gemini_ai.g.dart';

@Riverpod(keepAlive: true, dependencies: [GeminiAi])
FutureOr<GenerateContentResponse> randomText(RandomTextRef ref,
        {required String word}) =>
    ref.read(geminiAiProvider.notifier).randomText(word);

@Riverpod(keepAlive: true, dependencies: [PuzzleNotifier])
FutureOr<String> puzzleHint(PuzzleHintRef ref, String id) async {
  final PuzzleNotifier notifier = ref.watch(puzzleNotifierProvider(id));
  String nextWord = notifier.nextWord;
  return ref.watch(randomTextProvider(word: nextWord)).when(
        loading: () => ref.read(recallNextProvider),
        data: (data) => data.text ?? "Null value",
        error: (error, stackTrace) {
          debugPrintStack(stackTrace: stackTrace);
          return "Some Error";
        },
      );
}

@riverpod
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

  FutureOr<GenerateContentResponse> randomText(String word) {
    final List<String> splitter = word.split(' ');
    debugPrint(splitter.toString());
    final String prompt =
        'Give me short hint for word "$word" less than 24 words. '
        'Use simple english. '
        'Make sure that in the hint, do not include the words like ${splitter.first}, ${splitter.last} ';
    final List<Content> content = [Content.text(prompt)];
    return state.generateContent(content);
  }
}
