import 'package:intl/intl.dart';

extension IntExt on int {
  bool isPrev(int i) => i - 1 == this;
  bool isPrevPrev(int i) => this < i;
  bool isNext(int i) => this > i;
}

extension DateExt on DateTime {
  DateTime convert() {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateStr = formatter.format(this);
    final DateTime formatted = formatter.parse(dateStr);
    return formatted;
  }
}

extension StrExt on String {
  String get firstChar => isEmpty ? '' : substring(0, 1);
}
