// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerImpl _$$PlayerImplFromJson(Map<String, dynamic> json) => _$PlayerImpl(
      name: json['name'] as String?,
      rName: json['rName'] as String?,
      userId: json['userId'] as num?,
      email: json['email'] as String?,
      photoURL: json['photoURL'] as String?,
      nowTime: json['nowTime'] == null
          ? null
          : DateTime.parse(json['nowTime'] as String),
      id: json['id'] as String?,
      source: json['source'] as String?,
    );

Map<String, dynamic> _$$PlayerImplToJson(_$PlayerImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('rName', instance.rName);
  writeNotNull('userId', instance.userId);
  writeNotNull('email', instance.email);
  writeNotNull('photoURL', instance.photoURL);
  writeNotNull('nowTime', instance.nowTime?.toIso8601String());
  writeNotNull('id', instance.id);
  writeNotNull('source', instance.source);
  return val;
}
