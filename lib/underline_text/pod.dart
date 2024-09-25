import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/underline_text.dart';
part 'pod.g.dart';

@Riverpod(keepAlive: true)
UnderlineText title(TitleRef ref) {
  final DateTime now = DateTime.now();
  return _today[now.day % _today.length];
}

const List<UnderlineText> _today = [
  UnderlineText(
    "What word do you think comes next after this one?",
    focus: "comes next",
  ),
  UnderlineText(
    "Can you guess what the next word will be?",
    focus: "next word",
  ),
  UnderlineText(
    "What word follows this one in the sequence?",
    focus: "this one",
  ),
  UnderlineText("Which word do you think is next?", focus: "is next?"),
  UnderlineText("What do you think the next word is?", focus: "next word"),
  UnderlineText("Can you tell me the next word", focus: "next word"),
  UnderlineText(
    "What word comes after this one, in your opinion",
    focus: "comes after",
  ),
  UnderlineText("What do you believe is the next word", focus: "next word"),
  UnderlineText("Which word do you think will come next", focus: "come next"),
  UnderlineText("What’s your guess for the next word", focus: "next word"),
];
