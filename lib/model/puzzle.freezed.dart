// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'puzzle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Puzzle _$PuzzleFromJson(Map<String, dynamic> json) {
  return _Puzzle.fromJson(json);
}

/// @nodoc
mixin _$Puzzle {
  DateTime get date => throw _privateConstructorUsedError;
  List<Word> get words => throw _privateConstructorUsedError;
  List<String> get users => throw _privateConstructorUsedError;
  @JsonKey(includeToJson: false, includeFromJson: false)
  String? get id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PuzzleCopyWith<Puzzle> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PuzzleCopyWith<$Res> {
  factory $PuzzleCopyWith(Puzzle value, $Res Function(Puzzle) then) =
      _$PuzzleCopyWithImpl<$Res, Puzzle>;
  @useResult
  $Res call(
      {DateTime date,
      List<Word> words,
      List<String> users,
      @JsonKey(includeToJson: false, includeFromJson: false) String? id});
}

/// @nodoc
class _$PuzzleCopyWithImpl<$Res, $Val extends Puzzle>
    implements $PuzzleCopyWith<$Res> {
  _$PuzzleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? words = null,
    Object? users = null,
    Object? id = freezed,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      words: null == words
          ? _value.words
          : words // ignore: cast_nullable_to_non_nullable
              as List<Word>,
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<String>,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PuzzleImplCopyWith<$Res> implements $PuzzleCopyWith<$Res> {
  factory _$$PuzzleImplCopyWith(
          _$PuzzleImpl value, $Res Function(_$PuzzleImpl) then) =
      __$$PuzzleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      List<Word> words,
      List<String> users,
      @JsonKey(includeToJson: false, includeFromJson: false) String? id});
}

/// @nodoc
class __$$PuzzleImplCopyWithImpl<$Res>
    extends _$PuzzleCopyWithImpl<$Res, _$PuzzleImpl>
    implements _$$PuzzleImplCopyWith<$Res> {
  __$$PuzzleImplCopyWithImpl(
      _$PuzzleImpl _value, $Res Function(_$PuzzleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? words = null,
    Object? users = null,
    Object? id = freezed,
  }) {
    return _then(_$PuzzleImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      words: null == words
          ? _value._words
          : words // ignore: cast_nullable_to_non_nullable
              as List<Word>,
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<String>,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PuzzleImpl extends _Puzzle with DiagnosticableTreeMixin {
  const _$PuzzleImpl(
      {required this.date,
      required final List<Word> words,
      final List<String> users = const [],
      @JsonKey(includeToJson: false, includeFromJson: false) this.id})
      : _words = words,
        _users = users,
        super._();

  factory _$PuzzleImpl.fromJson(Map<String, dynamic> json) =>
      _$$PuzzleImplFromJson(json);

  @override
  final DateTime date;
  final List<Word> _words;
  @override
  List<Word> get words {
    if (_words is EqualUnmodifiableListView) return _words;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_words);
  }

  final List<String> _users;
  @override
  @JsonKey()
  List<String> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
  final String? id;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Puzzle(date: $date, words: $words, users: $users, id: $id)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Puzzle'))
      ..add(DiagnosticsProperty('date', date))
      ..add(DiagnosticsProperty('words', words))
      ..add(DiagnosticsProperty('users', users))
      ..add(DiagnosticsProperty('id', id));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PuzzleImpl &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._words, _words) &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      date,
      const DeepCollectionEquality().hash(_words),
      const DeepCollectionEquality().hash(_users),
      id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PuzzleImplCopyWith<_$PuzzleImpl> get copyWith =>
      __$$PuzzleImplCopyWithImpl<_$PuzzleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PuzzleImplToJson(
      this,
    );
  }
}

abstract class _Puzzle extends Puzzle {
  const factory _Puzzle(
      {required final DateTime date,
      required final List<Word> words,
      final List<String> users,
      @JsonKey(includeToJson: false, includeFromJson: false)
      final String? id}) = _$PuzzleImpl;
  const _Puzzle._() : super._();

  factory _Puzzle.fromJson(Map<String, dynamic> json) = _$PuzzleImpl.fromJson;

  @override
  DateTime get date;
  @override
  List<Word> get words;
  @override
  List<String> get users;
  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
  String? get id;
  @override
  @JsonKey(ignore: true)
  _$$PuzzleImplCopyWith<_$PuzzleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
