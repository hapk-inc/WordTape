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
  int get rowNo => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get mistake => throw _privateConstructorUsedError;
  DateTime? get lastFound => throw _privateConstructorUsedError; //
  @JsonKey(includeIfNull: false)
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
      {int rowNo,
      @JsonKey(includeIfNull: false) String? mistake,
      DateTime? lastFound,
      @JsonKey(includeIfNull: false) String? id});
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
    Object? rowNo = null,
    Object? mistake = freezed,
    Object? lastFound = freezed,
    Object? id = freezed,
  }) {
    return _then(_value.copyWith(
      rowNo: null == rowNo
          ? _value.rowNo
          : rowNo // ignore: cast_nullable_to_non_nullable
              as int,
      mistake: freezed == mistake
          ? _value.mistake
          : mistake // ignore: cast_nullable_to_non_nullable
              as String?,
      lastFound: freezed == lastFound
          ? _value.lastFound
          : lastFound // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      {int rowNo,
      @JsonKey(includeIfNull: false) String? mistake,
      DateTime? lastFound,
      @JsonKey(includeIfNull: false) String? id});
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
    Object? rowNo = null,
    Object? mistake = freezed,
    Object? lastFound = freezed,
    Object? id = freezed,
  }) {
    return _then(_$FoundImpl(
      rowNo: null == rowNo
          ? _value.rowNo
          : rowNo // ignore: cast_nullable_to_non_nullable
              as int,
      mistake: freezed == mistake
          ? _value.mistake
          : mistake // ignore: cast_nullable_to_non_nullable
              as String?,
      lastFound: freezed == lastFound
          ? _value.lastFound
          : lastFound // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _$FoundImpl implements _Found {
  const _$FoundImpl(
      {this.rowNo = 1,
      @JsonKey(includeIfNull: false) this.mistake,
      this.lastFound,
      @JsonKey(includeIfNull: false) this.id});

  factory _$FoundImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoundImplFromJson(json);

  @override
  @JsonKey()
  final int rowNo;
  @override
  @JsonKey(includeIfNull: false)
  final String? mistake;
  @override
  final DateTime? lastFound;
//
  @override
  @JsonKey(includeIfNull: false)
  final String? id;

  @override
  String toString() {
    return 'Found(rowNo: $rowNo, mistake: $mistake, lastFound: $lastFound, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoundImpl &&
            (identical(other.rowNo, rowNo) || other.rowNo == rowNo) &&
            (identical(other.mistake, mistake) || other.mistake == mistake) &&
            (identical(other.lastFound, lastFound) ||
                other.lastFound == lastFound) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, rowNo, mistake, lastFound, id);

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

abstract class _Found implements Found {
  const factory _Found(
      {final int rowNo,
      @JsonKey(includeIfNull: false) final String? mistake,
      final DateTime? lastFound,
      @JsonKey(includeIfNull: false) final String? id}) = _$FoundImpl;

  factory _Found.fromJson(Map<String, dynamic> json) = _$FoundImpl.fromJson;

  @override
  int get rowNo;
  @override
  @JsonKey(includeIfNull: false)
  String? get mistake;
  @override
  DateTime? get lastFound;
  @override //
  @JsonKey(includeIfNull: false)
  String? get id;
  @override
  @JsonKey(ignore: true)
  _$$FoundImplCopyWith<_$FoundImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
