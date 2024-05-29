// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'found.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoundImpl _$$FoundImplFromJson(Map<String, dynamic> json) => _$FoundImpl(
      rowNo: (json['rowNo'] as num?)?.toInt() ?? 1,
      mistake: json['mistake'] as String?,
      lastFound: json['lastFound'] == null
          ? null
          : DateTime.parse(json['lastFound'] as String),
    );

Map<String, dynamic> _$$FoundImplToJson(_$FoundImpl instance) {
  final val = <String, dynamic>{
    'rowNo': instance.rowNo,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('mistake', instance.mistake);
  val['lastFound'] = instance.lastFound?.toIso8601String();
  return val;
}
