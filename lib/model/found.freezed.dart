// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'found.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Found _$FoundFromJson(Map<String, dynamic> json) {
  return _Found.fromJson(json);
}

/// @nodoc
mixin _$Found {
  int get i => throw _privateConstructorUsedError;
  String? get mistake => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  List<String>? get revealed => throw _privateConstructorUsedError;
  DateTime? get lastFound => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  int? get hintUsed => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  int? get rank => throw _privateConstructorUsedError; //
  @JsonKey(includeToJson: false)
  String? get id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FoundCopyWith<Found> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoundCopyWith<$Res> {
  factory $FoundCopyWith(Found value, $Res Function(Found) then) =
      _$FoundCopyWithImpl<$Res, Found>;
  @useResult
  $Res call(
      {int i,
      String? mistake,
      @JsonKey(includeIfNull: false) List<String>? revealed,
      DateTime? lastFound,
      @JsonKey(includeIfNull: false) int? hintUsed,
      @JsonKey(includeIfNull: false) int? rank,
      @JsonKey(includeToJson: false) String? id});
}

/// @nodoc
class _$FoundCopyWithImpl<$Res, $Val extends Found>
    implements $FoundCopyWith<$Res> {
  _$FoundCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? i = null,
    Object? mistake = freezed,
    Object? revealed = freezed,
    Object? lastFound = freezed,
    Object? hintUsed = freezed,
    Object? rank = freezed,
    Object? id = freezed,
  }) {
    return _then(_value.copyWith(
      i: null == i
          ? _value.i
          : i // ignore: cast_nullable_to_non_nullable
              as int,
      mistake: freezed == mistake
          ? _value.mistake
          : mistake // ignore: cast_nullable_to_non_nullable
              as String?,
      revealed: freezed == revealed
          ? _value.revealed
          : revealed // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      lastFound: freezed == lastFound
          ? _value.lastFound
          : lastFound // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hintUsed: freezed == hintUsed
          ? _value.hintUsed
          : hintUsed // ignore: cast_nullable_to_non_nullable
              as int?,
      rank: freezed == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoundImplCopyWith<$Res> implements $FoundCopyWith<$Res> {
  factory _$$FoundImplCopyWith(
          _$FoundImpl value, $Res Function(_$FoundImpl) then) =
      __$$FoundImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int i,
      String? mistake,
      @JsonKey(includeIfNull: false) List<String>? revealed,
      DateTime? lastFound,
      @JsonKey(includeIfNull: false) int? hintUsed,
      @JsonKey(includeIfNull: false) int? rank,
      @JsonKey(includeToJson: false) String? id});
}

/// @nodoc
class __$$FoundImplCopyWithImpl<$Res>
    extends _$FoundCopyWithImpl<$Res, _$FoundImpl>
    implements _$$FoundImplCopyWith<$Res> {
  __$$FoundImplCopyWithImpl(
      _$FoundImpl _value, $Res Function(_$FoundImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? i = null,
    Object? mistake = freezed,
    Object? revealed = freezed,
    Object? lastFound = freezed,
    Object? hintUsed = freezed,
    Object? rank = freezed,
    Object? id = freezed,
  }) {
    return _then(_$FoundImpl(
      i: null == i
          ? _value.i
          : i // ignore: cast_nullable_to_non_nullable
              as int,
      mistake: freezed == mistake
          ? _value.mistake
          : mistake // ignore: cast_nullable_to_non_nullable
              as String?,
      revealed: freezed == revealed
          ? _value.revealed
          : revealed // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      lastFound: freezed == lastFound
          ? _value.lastFound
          : lastFound // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hintUsed: freezed == hintUsed
          ? _value.hintUsed
          : hintUsed // ignore: cast_nullable_to_non_nullable
              as int?,
      rank: freezed == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoundImpl extends _Found {
  const _$FoundImpl(
      {this.i = 1,
      this.mistake,
      @JsonKey(includeIfNull: false) this.revealed,
      this.lastFound,
      @JsonKey(includeIfNull: false) this.hintUsed,
      @JsonKey(includeIfNull: false) this.rank,
      @JsonKey(includeToJson: false) this.id})
      : super._();

  factory _$FoundImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoundImplFromJson(json);

  @override
  @JsonKey()
  final int i;
  @override
  final String? mistake;
  @override
  @JsonKey(includeIfNull: false)
  final List<String>? revealed;
  @override
  final DateTime? lastFound;
  @override
  @JsonKey(includeIfNull: false)
  final int? hintUsed;
  @override
  @JsonKey(includeIfNull: false)
  final int? rank;
//
  @override
  @JsonKey(includeToJson: false)
  final String? id;

  @override
  String toString() {
    return 'Found(i: $i, mistake: $mistake, revealed: $revealed, lastFound: $lastFound, hintUsed: $hintUsed, rank: $rank, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoundImpl &&
            (identical(other.i, i) || other.i == i) &&
            (identical(other.mistake, mistake) || other.mistake == mistake) &&
            const DeepCollectionEquality().equals(other.revealed, revealed) &&
            (identical(other.lastFound, lastFound) ||
                other.lastFound == lastFound) &&
            (identical(other.hintUsed, hintUsed) ||
                other.hintUsed == hintUsed) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      i,
      mistake,
      const DeepCollectionEquality().hash(revealed),
      lastFound,
      hintUsed,
      rank,
      id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FoundImplCopyWith<_$FoundImpl> get copyWith =>
      __$$FoundImplCopyWithImpl<_$FoundImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoundImplToJson(
      this,
    );
  }
}

abstract class _Found extends Found {
  const factory _Found(
      {final int i,
      final String? mistake,
      @JsonKey(includeIfNull: false) final List<String>? revealed,
      final DateTime? lastFound,
      @JsonKey(includeIfNull: false) final int? hintUsed,
      @JsonKey(includeIfNull: false) final int? rank,
      @JsonKey(includeToJson: false) final String? id}) = _$FoundImpl;
  const _Found._() : super._();

  factory _Found.fromJson(Map<String, dynamic> json) = _$FoundImpl.fromJson;

  @override
  int get i;
  @override
  String? get mistake;
  @override
  @JsonKey(includeIfNull: false)
  List<String>? get revealed;
  @override
  DateTime? get lastFound;
  @override
  @JsonKey(includeIfNull: false)
  int? get hintUsed;
  @override
  @JsonKey(includeIfNull: false)
  int? get rank;
  @override //
  @JsonKey(includeToJson: false)
  String? get id;
  @override
  @JsonKey(ignore: true)
  _$$FoundImplCopyWith<_$FoundImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
