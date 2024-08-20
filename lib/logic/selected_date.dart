import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'selected_date.g.dart';

@riverpod
class SelectedDate extends _$SelectedDate {
  @override
  DateTime build() => DateTime.now();

  @override
  set state(DateTime value) => super.state = value;
}
