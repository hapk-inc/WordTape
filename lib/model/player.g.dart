// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerImpl _$$PlayerImplFromJson(Map<String, dynamic> json) => _$PlayerImpl(
      name: json['name'] as String? ?? "User#",
      rName: json['rName'] as String?,
      userId: json['userId'] as num?,
      nowTime: json['nowTime'] == null
          ? null
          : DateTime.parse(json['nowTime'] as String),
      id: json['id'] as String?,
      source: json['source'] as String?,
    );

Map<String, dynamic> _$$PlayerImplToJson(_$PlayerImpl instance) {
  final val = <String, dynamic>{
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('rName', instance.rName);
  writeNotNull('userId', instance.userId);
  writeNotNull('nowTime', instance.nowTime?.toIso8601String());
  writeNotNull('id', instance.id);
  writeNotNull('source', instance.source);
  return val;
}
