import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../firebase/firebase.dart';
import '../../model/puzzle.dart';
import '../../model/word_event.dart';

class WordAnalytics {
  final Ref<WordAnalytics> ref;

  late FirebaseAnalytics analytics;
  late User? fUser;

  WordAnalytics(this.ref, {this.fUser}) {
    analytics = ref.read(firebaseAnalyticsProvider);
  }

  Future shareLog(Puzzle puzzle) async => analytics.logEvent(
        name: "puzzle_share",
        parameters: {
          "id": puzzle.id ?? "unknown",
          "user": fUser?.uid ?? "unknown",
          "puzzle_no": puzzle.puzzleNo,
          "method": kIsWeb ? "web" : "app"
        },
      ).whenComplete(() => debugPrint("puzzle_share done"));

  Future hintUsed(WordEvent wordEvent) => analytics.logEvent(
        name: "hint_used",
        parameters: {
          ...wordEvent.copyWith(user: fUser?.uid ?? "unknown").toJson()
        },
      );

  Future revealWord(WordEvent wordEvent) => analytics.logEvent(
        name: "reveal_word",
        parameters: {
          ...wordEvent.copyWith(user: fUser?.uid ?? "unknown").toJson()
        },
      );

  Future foundWord(WordEvent event) => analytics.logEvent(
        name: "found_word",
        parameters: {...event.copyWith(user: fUser?.uid ?? "unknown").toJson()},
      );

  // Future createUser(String id) => analytics.setUserId(id: id);
}

/*  Future shareLog(Puzzle puzzle) async => analytics.logShare(
        contentType: puzzle.puzzleNo,
        itemId: puzzle.id ?? "",
        method: kIsWeb ? "Web" : "App",
        parameters: {
          "user": fUser?.uid ?? "Unknown",
        },
      ).whenComplete(() => debugPrint("puzzle_share done"));*/
