import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dot_env.dart';

part 'gemini_ai.g.dart';

@Riverpod(keepAlive: true, dependencies: [GeminiAi])
FutureOr<GenerateContentResponse> randomText(RandomTextRef ref,
        {required String word}) =>
    ref.read(geminiAiProvider.notifier).randomText(word);

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
    const prompt =
        'Give me short hint for word "Show runner" less than 24 words. Use easy english';
    final content = [Content.text(prompt)];
    return state.generateContent(content);
  }
}
