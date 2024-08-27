import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'welcome_text.g.dart';
part 'welcome_text.freezed.dart';

@Freezed()
class WelcomeText with _$WelcomeText {
  const factory WelcomeText({
    required String text,
    required String sub,
    @Default("puzzle") String end,
  }) = _WelcomeText;
}

@Riverpod(keepAlive: true)
WelcomeText welcomeText(WelcomeTextRef ref, int index) => const [
      WelcomeText(
        text: "Discover concealed words in an entertaining ",
        sub: "and captivating ",
      ),
      WelcomeText(
        text: "Find secret words in an enjoyable ",
        sub: "and intriguing ",
      ),
      WelcomeText(
        text: "Reveal hidden words within a fun ",
        sub: "and engaging ",
      ),
      /*WelcomeText(
    text: "Unearth obscured words in an exciting ",
    sub: "and interactive ",
  ),*/
      WelcomeText(
        text: "Search for hidden words in a delightful ",
        sub: "and stimulating ",
      ),
      WelcomeText(
        text: "Explore masked words in a playful ",
        sub: "and fascinating ",
      ),
      WelcomeText(
        text: "Identify concealed words in a lively ",
        sub: "and enjoyable ",
      ),
      WelcomeText(
        text: "Hunt for hidden words in a charming ",
        sub: "and engaging ",
      ),
      WelcomeText(
        text: "Dig up secret words in a whimsical ",
        sub: "and captivating ",
      ),
      WelcomeText(
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
