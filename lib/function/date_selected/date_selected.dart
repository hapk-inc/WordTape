import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../extension/extension.dart';

part 'date_selected.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
class DateSelected extends _$DateSelected {
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
