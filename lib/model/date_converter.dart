import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

class DateConverter implements JsonConverter<DateTime, String> {
  const DateConverter();

  @override
  DateTime fromJson(String str) {
    DateTime dateTime = DateTime.parse(str);
    return dateTime;
  }

  @override
  String toJson(DateTime object) {
    final String dateStr = DateFormat('yyyy-MM-dd').format(object);
    return dateStr;
  }
}
