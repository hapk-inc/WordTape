import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/found.dart';

part 'found_notifier.g.dart';

@riverpod
class FoundNotifier extends _$FoundNotifier {
  @override
  FutureOr<Found> build(String id) async => const Found();
}
