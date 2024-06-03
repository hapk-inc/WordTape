// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'found.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoundImpl _$$FoundImplFromJson(Map<String, dynamic> json) => _$FoundImpl(
      i: (json['i'] as num?)?.toInt() ?? 1,
      mistake: json['mistake'] as String?,
      lastFound: json['lastFound'] == null
          ? null
          : DateTime.parse(json['lastFound'] as String),
      hintUsed: (json['hintUsed'] as num?)?.toInt(),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$$FoundImplToJson(_$FoundImpl instance) {
  final val = <String, dynamic>{
    'i': instance.i,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('mistake', instance.mistake);
  writeNotNull('lastFound', instance.lastFound?.toIso8601String());
  writeNotNull('hintUsed', instance.hintUsed);
  writeNotNull('id', instance.id);
  return val;
}
