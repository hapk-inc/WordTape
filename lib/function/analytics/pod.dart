import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'analytics_tracker.dart';

part 'pod.g.dart';

@Riverpod(keepAlive: true)
AnalyticsTracker analyticsTracker(Ref<AnalyticsTracker> ref) =>
    AnalyticsTracker(ref);

@Riverpod(keepAlive: true, dependencies: [analyticsTracker])
Future<void> questionCompleted(Ref ref,
    {int? i, required DateTime dateTime}) async {
  final AnalyticsTracker tracker = ref.read(analyticsTrackerProvider);
  return tracker.questionCompleted(i, dateTime);
}
