import 'package:json_annotation/json_annotation.dart';
import 'package:wordtape/model/converter/date_converter.dart';

class DoneConverter implements JsonConverter<List<DateTime>, List> {
  const DoneConverter();

  @override
  List<DateTime> fromJson(List<dynamic> json) {
    const DateConverter converter = DateConverter();
    return json.map((e) => converter.fromJson("$e")).toList();
  }

  @override
  List toJson(List<DateTime> list) {
    const DateConverter converter = DateConverter();
    return list.map((e) => converter.toJson(e)).toList();
  }

/*  @override
  List<DateTime> fromJson(String json) {
    final List list = json.split(',');
    return list.map((e) => DateTime.parse(e)).toList();
  }

  @override
  String toJson(List<DateTime> list) {
    return list.map((e) => DateFormat('yyyy-MM-dd').format(e)).join(",");
  }*/
}
