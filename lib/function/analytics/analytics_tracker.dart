import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';

import '../../firebase/pod.dart';

class AnalyticsTracker {
  final Ref ref;
  late FirebaseAnalytics _analytics;

  AnalyticsTracker(this.ref) {
    _analytics = ref.read(firebaseAnalyticsProvider);
  }

  Future<void> get timezone async {
    final String str = await FlutterTimezone.getLocalTimezone();
    return _analytics.logAppOpen(parameters: {"timezone": str});
  }

  Future<void> foundWord(String word, bool toastShown) async =>
      _analytics.logEvent(
        name: "word_found",
        parameters: {"word": word, "toast_shown": toastShown},
      );

  Future<void> questionCompleted(int? i, DateTime dateTime) async {
    final String found = DateFormat('MMM d, yyyy h:mm a').format(dateTime);
    return _analytics.logEvent(
      name: "question_completed",
      parameters: {"i": "$i", "last_found": found},
    );
  }
}

//if (found.date == null || found.lastFound == null) return;
// final String formattedDate = DateFormat('MMM d, yyyy').format(found.date!);
