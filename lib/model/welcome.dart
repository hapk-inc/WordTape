import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'welcome.g.dart';
part 'welcome.freezed.dart';

@Freezed()
class Welcome with _$Welcome {
  const factory Welcome({
    required String text,
    @Default("?") String end,
    String? highlight,
  }) = _Welcome;
}

const List<Welcome> _list = [
  Welcome(
    text: "What word do you think comes next after this one?",
    highlight: "comes next",
  ),
  Welcome(
    text: "Can you guess what the next word will be",
    highlight: "next word",
  ),
  Welcome(
    text: "What word follows this one in the sequence",
    highlight: "this one",
  ),
  Welcome(text: "Which word do you think is next", highlight: "is next"),
  Welcome(
    text: "What do you think the next word is",
    highlight: "next word",
  ),
  Welcome(text: "Can you tell me the next word", highlight: "next word"),
  Welcome(
    text: "What word comes after this one, in your opinion",
    highlight: "comes after",
  ),
  Welcome(text: "What do you believe is the next word", highlight: "next word"),
  Welcome(
      text: "Which word do you think will come next", highlight: "come next"),
  Welcome(text: "What’s your guess for the next word", highlight: "next word"),
];

@Riverpod(keepAlive: true)
Welcome welcome(WelcomeRef ref) {
  final DateTime now = DateTime.now();
  return _list[now.day % _list.length];
}

@riverpod
Welcome resume(ResumeRef ref) {
  final DateTime now = DateTime.now();
  return _resume[now.day % _resume.length];
}

const List<Welcome> _resume = [
  Welcome(
    text: "You're almost done! Keep going to finish the rest of the sequence",
    highlight: "almost",
    end: "",
  ),
  Welcome(
    text: "You're halfway through! Now, "
        "Finish the remaining part of the sequence.",
    highlight: "Finish ",
    end: "",
  ),
  Welcome(
    text: "Great job! Now try to  complete  the rest of the sequence.",
    highlight: "complete",
    end: "",
  ),
  Welcome(
    text: "You're doing well!  Finish  the rest of the sequence now.",
    highlight: "Finish",
    end: "",
  ),
  Welcome(
    text: "You're partway there!  Keep going  to complete the sequence.",
    highlight: "Keep going",
    end: "",
  ),
  Welcome(
    text: "You're halfway ! Now, see if you can finish the sequence.",
    highlight: "finish the sequence.",
    end: "",
  ),
  Welcome(
    text: "You're nearly there! Try to  finish  the rest of the sequence.",
    highlight: "finish",
    end: "",
  ),
  Welcome(
    text: "You're halfway complete! Keep going to  finish  the sequence.",
    highlight: "finish",
    end: "",
  ),
  Welcome(
    text: "Good work! Now, try to  complete  the rest of the sequence.",
    highlight: "complete",
    end: "",
  ),
  Welcome(
    text: "You're almost finished! See if you can  complete  the "
        "rest of the sequence.",
    highlight: "complete",
    end: "",
  )
];

@Riverpod(keepAlive: true)
String passText(PassTextRef ref) {
  final DateTime now = DateTime.now();
  return _pass[now.day % _pass.length];
}

List<String> _pass = [
  "Spread the Word",
  "Tell Your Friends",
  "Pass It On",
  "Invite Your Friends",
  "Send to Friends",
  "Let Friends Know",
  "Share with others",
  "Connect with Friends",
  "Spread the Love",
  "Share with Your Circle",
];

/*You're almost done! Keep going to finish the rest of the sequence.
You're halfway through! Now, finish the remaining part of the sequence.
Great job! Now try to complete the rest of the sequence.
You're doing well! Finish the rest of the sequence now.
You're partway there! Keep going to complete the sequence.
You're halfway! Now, see if you can finish the sequence.
You're nearly there! Try to finish the rest of the sequence.
You're halfway complete! Keep going to finish the sequence.
Good work! Now, try to complete the rest of the sequence.
You're almost finished! See if you can complete the rest of the sequence.*/
