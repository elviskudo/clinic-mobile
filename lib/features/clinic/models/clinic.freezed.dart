// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clinic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Clinic _$ClinicFromJson(Map<String, dynamic> json) {
  return _Clinic.fromJson(json);
}

/// @nodoc
mixin _$Clinic {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'clinic_name')
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'post_code')
  String? get zipCode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ClinicCopyWith<Clinic> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClinicCopyWith<$Res> {
  factory $ClinicCopyWith(Clinic value, $Res Function(Clinic) then) =
      _$ClinicCopyWithImpl<$Res, Clinic>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'clinic_name') String name,
      String? description,
      String? address,
      @JsonKey(name: 'post_code') String? zipCode});
}

/// @nodoc
class _$ClinicCopyWithImpl<$Res, $Val extends Clinic>
    implements $ClinicCopyWith<$Res> {
  _$ClinicCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? address = freezed,
    Object? zipCode = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      zipCode: freezed == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClinicImplCopyWith<$Res> implements $ClinicCopyWith<$Res> {
  factory _$$ClinicImplCopyWith(
          _$ClinicImpl value, $Res Function(_$ClinicImpl) then) =
      __$$ClinicImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'clinic_name') String name,
      String? description,
      String? address,
      @JsonKey(name: 'post_code') String? zipCode});
}

/// @nodoc
class __$$ClinicImplCopyWithImpl<$Res>
    extends _$ClinicCopyWithImpl<$Res, _$ClinicImpl>
    implements _$$ClinicImplCopyWith<$Res> {
  __$$ClinicImplCopyWithImpl(
      _$ClinicImpl _value, $Res Function(_$ClinicImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? address = freezed,
    Object? zipCode = freezed,
  }) {
    return _then(_$ClinicImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      zipCode: freezed == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClinicImpl implements _Clinic {
  const _$ClinicImpl(
      {this.id,
      @JsonKey(name: 'clinic_name') required this.name,
      this.description,
      this.address,
      @JsonKey(name: 'post_code') this.zipCode});

  factory _$ClinicImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClinicImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'clinic_name')
  final String name;
  @override
  final String? description;
  @override
  final String? address;
  @override
  @JsonKey(name: 'post_code')
  final String? zipCode;

  @override
  String toString() {
    return 'Clinic(id: $id, name: $name, description: $description, address: $address, zipCode: $zipCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClinicImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.zipCode, zipCode) || other.zipCode == zipCode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, description, address, zipCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ClinicImplCopyWith<_$ClinicImpl> get copyWith =>
      __$$ClinicImplCopyWithImpl<_$ClinicImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClinicImplToJson(
      this,
    );
  }
}

abstract class _Clinic implements Clinic {
  const factory _Clinic(
      {final int? id,
      @JsonKey(name: 'clinic_name') required final String name,
      final String? description,
      final String? address,
      @JsonKey(name: 'post_code') final String? zipCode}) = _$ClinicImpl;

  factory _Clinic.fromJson(Map<String, dynamic> json) = _$ClinicImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'clinic_name')
  String get name;
  @override
  String? get description;
  @override
  String? get address;
  @override
  @JsonKey(name: 'post_code')
  String? get zipCode;
  @override
  @JsonKey(ignore: true)
  _$$ClinicImplCopyWith<_$ClinicImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
