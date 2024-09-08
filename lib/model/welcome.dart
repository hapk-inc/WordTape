import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'welcome.g.dart';
part 'welcome.freezed.dart';

@Freezed()
class Welcome with _$Welcome {
  const factory Welcome(
    String text, {
    @Default("?") String end,
    String? highlight,
  }) = _Welcome;
}

const List<Welcome> _list = [
  Welcome(
    "What word do you think comes next after this one?",
    highlight: "comes next",
  ),
  Welcome(
    "Can you guess what the next word will be",
    highlight: "next word",
  ),
  Welcome(
    "What word follows this one in the sequence",
    highlight: "this one",
  ),
  Welcome("Which word do you think is next", highlight: "is next"),
  Welcome(
    "What do you think the next word is",
    highlight: "next word",
  ),
  Welcome("Can you tell me the next word", highlight: "next word"),
  Welcome(
    "What word comes after this one, in your opinion",
    highlight: "comes after",
  ),
  Welcome("What do you believe is the next word", highlight: "next word"),
  Welcome("Which word do you think will come next", highlight: "come next"),
  Welcome("What’s your guess for the next word", highlight: "next word"),
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
    "You're almost done! Keep going to finish the rest of the sequence",
    highlight: "almost",
    end: "",
  ),
  Welcome(
    "You're halfway through! Now, "
    "Finish the remaining part of the sequence.",
    highlight: "Finish ",
    end: "",
  ),
  Welcome(
    "Great job! Now try to  complete  the rest of the sequence.",
    highlight: "complete",
    end: "",
  ),
  Welcome(
    "You're doing well!  Finish  the rest of the sequence now.",
    highlight: "Finish",
    end: "",
  ),
  Welcome(
    "You're partway there!  Keep going  to complete the sequence.",
    highlight: "Keep going",
    end: "",
  ),
  Welcome(
    "You're halfway ! Now, see if you can finish the sequence.",
    highlight: "finish the sequence.",
    end: "",
  ),
  Welcome(
    "You're nearly there! Try to  finish  the rest of the sequence.",
    highlight: "finish",
    end: "",
  ),
  Welcome(
    "You're halfway complete! Keep going to finish the sequence",
    highlight: "finish the sequence",
    end: ".",
  ),
  Welcome(
    "Good work! Now, try to complete the rest of the sequence.",
    highlight: "complete",
    end: "",
  ),
  Welcome(
    "You're almost finished! See if you can complete the sequence.",
    highlight: "complete",
    end: "",
  )
];

@Riverpod(keepAlive: true)
String passText(PassTextRef ref) {
  final DateTime now = DateTime.now();
  return _pass[now.day % _pass.length];
}

@Riverpod(keepAlive: true)
Welcome archiveText(ArchiveTextRef ref) {
  final DateTime now = DateTime.now();
  return _archive[now.day % _archive.length];
}

const List<String> _pass = [
  "Spread the Word",
  "Tell Your Friends",
  "Pass It On",
  "Invite Your Friends",
  "Send to Friends",
  "Let Friends Know",
  "Share with others",
  "Connect with Friends",
];

const List<Welcome> _archive = [
  Welcome(
    "Want to check out\n archives and play?",
    highlight: "archives and play?",
  ),
  Welcome("Would you like to\n visit the archives?",
      highlight: "visit the archives?"),
  Welcome("How about looking at the archives and playing?"),
  Welcome("Interested in seeing the archives and playing?"),
  Welcome("Want to explore the archives and have fun?"),
  Welcome("Shall we check the archives and play?"),
  Welcome("Do you want to see and play?"),
  Welcome("Care to look at the archives and play?"),
];
