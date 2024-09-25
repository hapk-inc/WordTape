import 'package:intl/intl.dart';

extension DateExt on DateTime {
  DateTime convert() {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateStr = formatter.format(this);
    final DateTime formatted = formatter.parse(dateStr);
    return formatted;
  }
}
