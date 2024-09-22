import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'welcome.g.dart';
part 'welcome.freezed.dart';

@Freezed()
class Welcome with _$Welcome {
  const factory Welcome(String text,
      {@Default("") String end, String? highlight}) = _Welcome;
}

const List<Welcome> _list = [
  Welcome(
    "What word do you think comes next after this one?",
    highlight: "comes next",
  ),
  Welcome("Can you guess what the next word will be?", highlight: "next word"),
  Welcome(
    "What word follows this one in the sequence?",
    highlight: "this one",
  ),
  Welcome("Which word do you think is next?", highlight: "is next?"),
  Welcome("What do you think the next word is?", highlight: "next word"),
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
  ),
  Welcome(
    "You're halfway through! Now, Finish the remaining sequence.",
    highlight: "Finish ",
  ),
  Welcome(
    "Great job! Now try to complete the rest of the sequence.",
    highlight: "complete",
  ),
  Welcome(
    "You're doing well! Finish the rest of the sequence now.",
    highlight: "Finish",
  ),
  Welcome(
    "You're partway there!  Keep going  to complete the sequence.",
    highlight: "Keep going",
  ),
  Welcome(
    "You're halfway ! Now, see if you can finish the sequence.",
    highlight: "finish the sequence.",
  ),
  Welcome(
    "You're nearly there! Try to finish the rest of the sequence.",
    highlight: "finish sequence.",
  ),
  Welcome(
    "You're halfway complete! Keep going to finish the sequence",
    highlight: "finish the sequence",
  ),
  Welcome(
    "Good work! Now, try to complete the rest of the sequence.",
    highlight: "complete",
  ),
  Welcome(
    "You're almost finished! See if you can complete the sequence.",
    highlight: "complete",
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
  Welcome(
    "Would you like to\n visit the archives?",
    highlight: "visit the archives?",
  ),
  Welcome(
    "How about looking at the\n archives and playing?",
    highlight: "archives and playing?",
  ),
  Welcome(
    "Interested in seeing the\n archives and playing?",
    highlight: "archives and playing?",
  ),
  Welcome(
    "Want to explore the\n archives and have fun?",
    highlight: "archives and have fun?",
  ),
  Welcome(
    "Shall we check the\n archives and play?",
    highlight: "archives and play?",
  ),
  Welcome("Care to look at the\n archives and play?",
      highlight: "archives and play?"),
];

@riverpod
String fillText(FillTextRef ref) {
  final DateTime now = DateTime.now();
  return _fillText[now.day % _fillText.length];
}

const _fillText = [
  "Complete the full text",
  "Provide all the required text",
  "Enter the complete text",
  "Fill in the entire content",
  "Write out the complete text"
];

@riverpod
String completePuzzle(CompletePuzzleRef ref) {
  final DateTime now = DateTime.now();
  return _completeText[now.day % _completeText.length];
}

const List<String> _completeText = [
  "Great job! You finished today’s puzzle.",
  "Well done! You solved the puzzle for today.",
  "Awesome! You did today’s puzzle.",
  "Nice work! You completed the puzzle today.",
  "Good job! You figured out today’s puzzle.",
  "Way to go! You finished the puzzle for today.",
  "You did it! You solved today’s challenge.",
  "Hooray! You completed the puzzle today.",
  "Fantastic! You finished the puzzle for today.",
  "Cheers! You solved today’s puzzle"
];

@riverpod
Welcome completeWelcome(CompleteWelcomeRef ref) {
  final DateTime now = DateTime.now();
  return _completeWelcome[now.day % _completeWelcome.length];
}

const List<Welcome> _completeWelcome = [
  Welcome("Great job! \nYou finished today’s puzzle.", highlight: "Great job!"),
  Welcome(
    "Well done! \nYou solved the puzzle for today.",
    highlight: "Well done!",
  ),
  Welcome("Awesome! \nYou did today’s puzzle.", highlight: "Awesome!"),
  Welcome(
    "Nice work! \nYou completed the puzzle today.",
    highlight: "Nice work!",
  ),
  Welcome(
    "Good job! \nYou figured out today’s puzzle.",
    highlight: "Good job!",
  ),
  Welcome(
    "Way to go! \nYou finished the puzzle for today.",
    highlight: "Way to go!",
  ),
  Welcome(
    "You did it! \nYou solved today’s challenge.",
    highlight: "You did it!",
  ),
  Welcome("Hooray! \nYou completed the puzzle today.", highlight: "Hooray!"),
  Welcome(
    "Fantastic! \nYou finished the puzzle for today.",
    highlight: "Fantastic!",
  ),
  Welcome("Cheers! \nYou solved today’s puzzle", highlight: "Cheers!"),
];

@riverpod
String passDetail(PassDetailRef ref) {
  final DateTime now = DateTime.now();
  return _passDetail[now.day % _passDetail.length];
}

List<String> _passDetail = [
  "Ask your friends to join the puzzle and see if they can solve it.",
  "Tell your friends to come play the puzzle and find out if they can get it.",
  "Invite your friends to play the puzzle and check if they can find it.",
  "Bring your friends to the puzzle and see if they can figure it out.",
  "Have your friends join the puzzle and see if they can spot it.",
  "Get your friends to take part in the puzzle and see if they can discover it.",
  "Invite your pals to the puzzle and see if they can find the answer.",
  "Ask your buddies to join in the puzzle and see if they can solve it.",
  "Encourage your friends to join the puzzle and find out if they can get it right.",
  "Invite your friends to try the puzzle and see if they can figure it out."
];

List<String> charExist(String t) => [
      "The letter $t can also be found in the word.",
      "The word contains the letter $t.",
      "You can find the letter $t in the word too.",
      "The letter $t appears in the word.",
      "Additionally, the letter $t is present in the word.",
      "The word includes the letter $t too.",
      "The letter $t is part of the word.",
      "The word also features the letter $t.",
      "You’ll also see the letter $t in the word.",
      "The letter $t is included in the word.",
    ];
