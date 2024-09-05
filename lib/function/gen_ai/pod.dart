import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mock_data/mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../env/pod.dart';

part 'pod.g.dart';

@Riverpod(dependencies: [GeminiAi])
Future<String> createHint(CreateHintRef ref, {required String word}) async {
  final GeminiAi ai = ref.read(geminiAiProvider.notifier);
  return ai.generateHint(word);
}

@Riverpod()
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

  FutureOr<String> generateHint(String word) async {
    final List<String> splitter = word.split(' ');
    debugPrint(splitter.toString());
    final String prompt =
        'Give me short hint for word "$word" less than 15 words. '
        'Use simple english. '
        'Make sure that in the hint, do not include the words like ${splitter.join(", ")}';
    final List<Content> content = [Content.text(prompt)];
    final GenerateContentResponse model = await state.generateContent(content);
    return model.text ?? "Think";
  }
}
