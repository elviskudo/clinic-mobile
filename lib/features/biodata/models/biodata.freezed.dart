// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'biodata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Biodata _$BiodataFromJson(Map<String, dynamic> json) {
  return _Biodata.fromJson(json);
}

/// @nodoc
mixin _$Biodata {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'fullname')
  String? get fullName => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_place')
  String? get placeOfBirth => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date')
  DateTime? get dateOfBirth => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  @JsonKey(name: 'no_identity')
  String? get nik => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'area_code')
  String? get postalCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'responsible_for_costs')
  String? get responsibleForCosts => throw _privateConstructorUsedError;
  @JsonKey(name: 'blood_type')
  String? get bloodType => throw _privateConstructorUsedError;
  City? get city => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BiodataCopyWith<Biodata> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BiodataCopyWith<$Res> {
  factory $BiodataCopyWith(Biodata value, $Res Function(Biodata) then) =
      _$BiodataCopyWithImpl<$Res, Biodata>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'fullname') String? fullName,
      @JsonKey(name: 'birth_place') String? placeOfBirth,
      @JsonKey(name: 'birth_date') DateTime? dateOfBirth,
      String? gender,
      @JsonKey(name: 'no_identity') String? nik,
      String? address,
      @JsonKey(name: 'area_code') String? postalCode,
      @JsonKey(name: 'responsible_for_costs') String? responsibleForCosts,
      @JsonKey(name: 'blood_type') String? bloodType,
      City? city});

  $CityCopyWith<$Res>? get city;
}

/// @nodoc
class _$BiodataCopyWithImpl<$Res, $Val extends Biodata>
    implements $BiodataCopyWith<$Res> {
  _$BiodataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? fullName = freezed,
    Object? placeOfBirth = freezed,
    Object? dateOfBirth = freezed,
    Object? gender = freezed,
    Object? nik = freezed,
    Object? address = freezed,
    Object? postalCode = freezed,
    Object? responsibleForCosts = freezed,
    Object? bloodType = freezed,
    Object? city = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      placeOfBirth: freezed == placeOfBirth
          ? _value.placeOfBirth
          : placeOfBirth // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      nik: freezed == nik
          ? _value.nik
          : nik // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      responsibleForCosts: freezed == responsibleForCosts
          ? _value.responsibleForCosts
          : responsibleForCosts // ignore: cast_nullable_to_non_nullable
              as String?,
      bloodType: freezed == bloodType
          ? _value.bloodType
          : bloodType // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as City?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CityCopyWith<$Res>? get city {
    if (_value.city == null) {
      return null;
    }

    return $CityCopyWith<$Res>(_value.city!, (value) {
      return _then(_value.copyWith(city: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BiodataImplCopyWith<$Res> implements $BiodataCopyWith<$Res> {
  factory _$$BiodataImplCopyWith(
          _$BiodataImpl value, $Res Function(_$BiodataImpl) then) =
      __$$BiodataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'fullname') String? fullName,
      @JsonKey(name: 'birth_place') String? placeOfBirth,
      @JsonKey(name: 'birth_date') DateTime? dateOfBirth,
      String? gender,
      @JsonKey(name: 'no_identity') String? nik,
      String? address,
      @JsonKey(name: 'area_code') String? postalCode,
      @JsonKey(name: 'responsible_for_costs') String? responsibleForCosts,
      @JsonKey(name: 'blood_type') String? bloodType,
      City? city});

  @override
  $CityCopyWith<$Res>? get city;
}

/// @nodoc
class __$$BiodataImplCopyWithImpl<$Res>
    extends _$BiodataCopyWithImpl<$Res, _$BiodataImpl>
    implements _$$BiodataImplCopyWith<$Res> {
  __$$BiodataImplCopyWithImpl(
      _$BiodataImpl _value, $Res Function(_$BiodataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? fullName = freezed,
    Object? placeOfBirth = freezed,
    Object? dateOfBirth = freezed,
    Object? gender = freezed,
    Object? nik = freezed,
    Object? address = freezed,
    Object? postalCode = freezed,
    Object? responsibleForCosts = freezed,
    Object? bloodType = freezed,
    Object? city = freezed,
  }) {
    return _then(_$BiodataImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      placeOfBirth: freezed == placeOfBirth
          ? _value.placeOfBirth
          : placeOfBirth // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      nik: freezed == nik
          ? _value.nik
          : nik // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      responsibleForCosts: freezed == responsibleForCosts
          ? _value.responsibleForCosts
          : responsibleForCosts // ignore: cast_nullable_to_non_nullable
              as String?,
      bloodType: freezed == bloodType
          ? _value.bloodType
          : bloodType // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as City?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BiodataImpl extends _Biodata {
  const _$BiodataImpl(
      {this.id,
      @JsonKey(name: 'fullname') this.fullName,
      @JsonKey(name: 'birth_place') this.placeOfBirth,
      @JsonKey(name: 'birth_date') this.dateOfBirth,
      this.gender,
      @JsonKey(name: 'no_identity') this.nik,
      this.address,
      @JsonKey(name: 'area_code') this.postalCode,
      @JsonKey(name: 'responsible_for_costs') this.responsibleForCosts,
      @JsonKey(name: 'blood_type') this.bloodType,
      this.city})
      : super._();

  factory _$BiodataImpl.fromJson(Map<String, dynamic> json) =>
      _$$BiodataImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'fullname')
  final String? fullName;
  @override
  @JsonKey(name: 'birth_place')
  final String? placeOfBirth;
  @override
  @JsonKey(name: 'birth_date')
  final DateTime? dateOfBirth;
  @override
  final String? gender;
  @override
  @JsonKey(name: 'no_identity')
  final String? nik;
  @override
  final String? address;
  @override
  @JsonKey(name: 'area_code')
  final String? postalCode;
  @override
  @JsonKey(name: 'responsible_for_costs')
  final String? responsibleForCosts;
  @override
  @JsonKey(name: 'blood_type')
  final String? bloodType;
  @override
  final City? city;

  @override
  String toString() {
    return 'Biodata(id: $id, fullName: $fullName, placeOfBirth: $placeOfBirth, dateOfBirth: $dateOfBirth, gender: $gender, nik: $nik, address: $address, postalCode: $postalCode, responsibleForCosts: $responsibleForCosts, bloodType: $bloodType, city: $city)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BiodataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.placeOfBirth, placeOfBirth) ||
                other.placeOfBirth == placeOfBirth) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.nik, nik) || other.nik == nik) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.responsibleForCosts, responsibleForCosts) ||
                other.responsibleForCosts == responsibleForCosts) &&
            (identical(other.bloodType, bloodType) ||
                other.bloodType == bloodType) &&
            (identical(other.city, city) || other.city == city));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      fullName,
      placeOfBirth,
      dateOfBirth,
      gender,
      nik,
      address,
      postalCode,
      responsibleForCosts,
      bloodType,
      city);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BiodataImplCopyWith<_$BiodataImpl> get copyWith =>
      __$$BiodataImplCopyWithImpl<_$BiodataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BiodataImplToJson(
      this,
    );
  }
}

abstract class _Biodata extends Biodata {
  const factory _Biodata(
      {final int? id,
      @JsonKey(name: 'fullname') final String? fullName,
      @JsonKey(name: 'birth_place') final String? placeOfBirth,
      @JsonKey(name: 'birth_date') final DateTime? dateOfBirth,
      final String? gender,
      @JsonKey(name: 'no_identity') final String? nik,
      final String? address,
      @JsonKey(name: 'area_code') final String? postalCode,
      @JsonKey(name: 'responsible_for_costs') final String? responsibleForCosts,
      @JsonKey(name: 'blood_type') final String? bloodType,
      final City? city}) = _$BiodataImpl;
  const _Biodata._() : super._();

  factory _Biodata.fromJson(Map<String, dynamic> json) = _$BiodataImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'fullname')
  String? get fullName;
  @override
  @JsonKey(name: 'birth_place')
  String? get placeOfBirth;
  @override
  @JsonKey(name: 'birth_date')
  DateTime? get dateOfBirth;
  @override
  String? get gender;
  @override
  @JsonKey(name: 'no_identity')
  String? get nik;
  @override
  String? get address;
  @override
  @JsonKey(name: 'area_code')
  String? get postalCode;
  @override
  @JsonKey(name: 'responsible_for_costs')
  String? get responsibleForCosts;
  @override
  @JsonKey(name: 'blood_type')
  String? get bloodType;
  @override
  City? get city;
  @override
  @JsonKey(ignore: true)
  _$$BiodataImplCopyWith<_$BiodataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
