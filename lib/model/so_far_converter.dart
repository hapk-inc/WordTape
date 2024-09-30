import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

class SoFarConverter implements JsonConverter<Map<int, dynamic>, String> {
  const SoFarConverter();

  @override
  Map<int, dynamic> fromJson(String json) {
    if (json.isEmpty) return {};
    final Map<String, dynamic> m = Map<String, dynamic>.from(jsonDecode(json));
    Map<int, dynamic> map = {};
    for (MapEntry<String, dynamic> x in m.entries) {
      map[int.parse(x.key)] = x.value;
    }
    return map;
  }

  @override
  String toJson(Map<int, dynamic> object) {
    Map<String, dynamic> map = {};
    for (MapEntry<int, dynamic> m in object.entries) {
      map["${m.key}"] = m.value;
    }

    final String str = jsonEncode(map);
    return str;
  }
}
