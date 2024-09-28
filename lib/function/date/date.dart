import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/date_ext.dart';

part 'date.g.dart';

@Riverpod(keepAlive: true)
DateTime now(NowRef ref) => DateTime.now().convert();

@Riverpod(keepAlive: true, dependencies: [])
class SelectedDate extends _$SelectedDate {
  @override
  DateTime build() {
    final DateTime now = DateTime.now();
    return now.convert();
  }

  @override
  set state(DateTime value) {
    if (super.state == value) return;
    super.state = value.convert();
  }
}
