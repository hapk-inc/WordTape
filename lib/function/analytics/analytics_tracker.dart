import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';

import '../../firebase/pod.dart';
import '../../model/found.dart';

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

  Future<void> puzzleDone(Found found) async {
    if (found.date == null || found.lastFound == null) return;
    final String formattedDate = DateFormat('MMM d, yyyy').format(found.date!);
    final String lastFound =
        DateFormat('MMM d, yyyy h:mm a').format(found.lastFound!);
    return _analytics.logEvent(
      name: "puzzle_done",
      parameters: {"date": formattedDate, "found": lastFound},
    );
  }
}
