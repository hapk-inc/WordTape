import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'pod.g.dart';

@riverpod
DateTime jun10(Jun10Ref ref) => DateTime(2024, 6, 10);

@Riverpod(keepAlive: true, dependencies: [])
class SelectedDate extends _$SelectedDate {
  @override
  DateTime build() => DateTime.now();

  @override
  set state(DateTime value) {
    if (super.state == value) return;

    super.state = value;
  }
}
