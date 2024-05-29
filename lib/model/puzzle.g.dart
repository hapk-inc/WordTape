// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PuzzleImpl _$$PuzzleImplFromJson(Map<String, dynamic> json) => _$PuzzleImpl(
      date: DateTime.parse(json['date'] as String),
      words: (json['words'] as List<dynamic>)
          .map((e) => Word.fromJson(e as Map<String, dynamic>))
          .toList(),
      users:
          (json['users'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$PuzzleImplToJson(_$PuzzleImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'words': instance.words,
      'users': instance.users,
    };
