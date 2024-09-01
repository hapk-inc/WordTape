import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'welcome.g.dart';
part 'welcome.freezed.dart';

@Freezed()
class Welcome with _$Welcome {
  const factory Welcome({
    required String text,
    required String sub,
    @Default("puzzle") String end,
  }) = _Welcome;
}

@Riverpod(keepAlive: true)
Welcome welcome(WelcomeRef ref, int index) => const [
      Welcome(
        text: "Discover concealed words in an entertaining ",
        sub: "and captivating ",
      ),
      Welcome(
        text: "Find secret words in an enjoyable ",
        sub: "and intriguing ",
      ),
      Welcome(
        text: "Reveal hidden words 🔎  within a fun ",
        sub: "and engaging ",
      ),
      Welcome(
        text: "Unearth obscured words in an exciting ",
        sub: "and interactive ",
      ),
      Welcome(
        text: "Search for hidden words in a delightful ",
        sub: "and stimulating ",
      ),
      Welcome(
        text: "Explore masked words in a playful ",
        sub: "and fascinating ",
      ),
      Welcome(
        text: "Identify concealed words in a lively ",
        sub: "and enjoyable ",
      ),
      Welcome(
        text: "Hunt for hidden words in a charming ",
        sub: "and engaging ",
      ),
      Welcome(
        text: "Dig up secret words in a whimsical ",
        sub: "and captivating ",
      ),
      Welcome(
        text: "Locate hidden words in a fun-filled ",
        sub: "and challenging ",
      ),
    ][index % 9];

/*
Here are ten rephrased versions of your line, each concluding with the word "puzzle":
"Discover concealed words in an entertaining and captivating puzzle."
"Find secret words in an enjoyable and intriguing puzzle."
"Reveal hidden words within a fun and engaging puzzle."
"Unearth obscured words in an exciting and interactive puzzle."
"Search for hidden words in a delightful and stimulating puzzle."
"Explore masked words in a playful and fascinating puzzle."
"Identify concealed words in a lively and enjoyable puzzle."
"Hunt for hidden words in a charming and engaging puzzle."
"Dig up secret words in a whimsical and captivating puzzle."
"Locate hidden words in a fun-filled and challenging puzzle."
* */
