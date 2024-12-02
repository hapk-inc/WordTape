extension IntExt on int {
  bool isPrev(int i) => i - 1 == this;
  bool isPrevPrev(int i) => this < i;
  bool isNext(int i) => this > i;
}

extension DateExt on DateTime {
  DateTime get onlyYYYYMMMDD {
    final DateTime formatted = DateTime(year, month, day);
    return formatted;
  }
}

extension StrExt on String {
  String get firstChar => isEmpty ? '' : substring(0, 1);
}
