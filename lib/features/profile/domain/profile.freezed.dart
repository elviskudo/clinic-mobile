// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return _Profile.fromJson(json);
}

/// @nodoc
mixin _$Profile {
  @JsonKey(name: 'fullname')
  String get fullName => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_number')
  String? get phoneNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_image')
  String? get avatar => throw _privateConstructorUsedError;
  @JsonKey(name: 'no_identity')
  String? get nik => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date')
  DateTime? get dateOfBirth => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_place')
  String? get placeOfBirth => throw _privateConstructorUsedError;
  @JsonKey(name: 'work_in')
  String? get workPlace => throw _privateConstructorUsedError;
  @JsonKey(name: 'blood_type')
  String? get bloodType => throw _privateConstructorUsedError;
  @JsonKey(name: 'marital_status')
  String? get maritalStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'responsibleForCosts')
  String? get insurance => throw _privateConstructorUsedError;
  @JsonKey(name: 'area_code')
  String? get postCode => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get nationality => throw _privateConstructorUsedError;
  String? get religion => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileCopyWith<Profile> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileCopyWith<$Res> {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) then) =
      _$ProfileCopyWithImpl<$Res, Profile>;
  @useResult
  $Res call(
      {@JsonKey(name: 'fullname') String fullName,
      @JsonKey(name: 'phone_number') String? phoneNumber,
      @JsonKey(name: 'profile_image') String? avatar,
      @JsonKey(name: 'no_identity') String? nik,
      @JsonKey(name: 'birth_date') DateTime? dateOfBirth,
      @JsonKey(name: 'birth_place') String? placeOfBirth,
      @JsonKey(name: 'work_in') String? workPlace,
      @JsonKey(name: 'blood_type') String? bloodType,
      @JsonKey(name: 'marital_status') String? maritalStatus,
      @JsonKey(name: 'responsibleForCosts') String? insurance,
      @JsonKey(name: 'area_code') String? postCode,
      String? gender,
      String? address,
      String? nationality,
      String? religion});
}

/// @nodoc
class _$ProfileCopyWithImpl<$Res, $Val extends Profile>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? phoneNumber = freezed,
    Object? avatar = freezed,
    Object? nik = freezed,
    Object? dateOfBirth = freezed,
    Object? placeOfBirth = freezed,
    Object? workPlace = freezed,
    Object? bloodType = freezed,
    Object? maritalStatus = freezed,
    Object? insurance = freezed,
    Object? postCode = freezed,
    Object? gender = freezed,
    Object? address = freezed,
    Object? nationality = freezed,
    Object? religion = freezed,
  }) {
    return _then(_value.copyWith(
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      nik: freezed == nik
          ? _value.nik
          : nik // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      placeOfBirth: freezed == placeOfBirth
          ? _value.placeOfBirth
          : placeOfBirth // ignore: cast_nullable_to_non_nullable
              as String?,
      workPlace: freezed == workPlace
          ? _value.workPlace
          : workPlace // ignore: cast_nullable_to_non_nullable
              as String?,
      bloodType: freezed == bloodType
          ? _value.bloodType
          : bloodType // ignore: cast_nullable_to_non_nullable
              as String?,
      maritalStatus: freezed == maritalStatus
          ? _value.maritalStatus
          : maritalStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      insurance: freezed == insurance
          ? _value.insurance
          : insurance // ignore: cast_nullable_to_non_nullable
              as String?,
      postCode: freezed == postCode
          ? _value.postCode
          : postCode // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      nationality: freezed == nationality
          ? _value.nationality
          : nationality // ignore: cast_nullable_to_non_nullable
              as String?,
      religion: freezed == religion
          ? _value.religion
          : religion // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileImplCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$$ProfileImplCopyWith(
          _$ProfileImpl value, $Res Function(_$ProfileImpl) then) =
      __$$ProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'fullname') String fullName,
      @JsonKey(name: 'phone_number') String? phoneNumber,
      @JsonKey(name: 'profile_image') String? avatar,
      @JsonKey(name: 'no_identity') String? nik,
      @JsonKey(name: 'birth_date') DateTime? dateOfBirth,
      @JsonKey(name: 'birth_place') String? placeOfBirth,
      @JsonKey(name: 'work_in') String? workPlace,
      @JsonKey(name: 'blood_type') String? bloodType,
      @JsonKey(name: 'marital_status') String? maritalStatus,
      @JsonKey(name: 'responsibleForCosts') String? insurance,
      @JsonKey(name: 'area_code') String? postCode,
      String? gender,
      String? address,
      String? nationality,
      String? religion});
}

/// @nodoc
class __$$ProfileImplCopyWithImpl<$Res>
    extends _$ProfileCopyWithImpl<$Res, _$ProfileImpl>
    implements _$$ProfileImplCopyWith<$Res> {
  __$$ProfileImplCopyWithImpl(
      _$ProfileImpl _value, $Res Function(_$ProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? phoneNumber = freezed,
    Object? avatar = freezed,
    Object? nik = freezed,
    Object? dateOfBirth = freezed,
    Object? placeOfBirth = freezed,
    Object? workPlace = freezed,
    Object? bloodType = freezed,
    Object? maritalStatus = freezed,
    Object? insurance = freezed,
    Object? postCode = freezed,
    Object? gender = freezed,
    Object? address = freezed,
    Object? nationality = freezed,
    Object? religion = freezed,
  }) {
    return _then(_$ProfileImpl(
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      nik: freezed == nik
          ? _value.nik
          : nik // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      placeOfBirth: freezed == placeOfBirth
          ? _value.placeOfBirth
          : placeOfBirth // ignore: cast_nullable_to_non_nullable
              as String?,
      workPlace: freezed == workPlace
          ? _value.workPlace
          : workPlace // ignore: cast_nullable_to_non_nullable
              as String?,
      bloodType: freezed == bloodType
          ? _value.bloodType
          : bloodType // ignore: cast_nullable_to_non_nullable
              as String?,
      maritalStatus: freezed == maritalStatus
          ? _value.maritalStatus
          : maritalStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      insurance: freezed == insurance
          ? _value.insurance
          : insurance // ignore: cast_nullable_to_non_nullable
              as String?,
      postCode: freezed == postCode
          ? _value.postCode
          : postCode // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      nationality: freezed == nationality
          ? _value.nationality
          : nationality // ignore: cast_nullable_to_non_nullable
              as String?,
      religion: freezed == religion
          ? _value.religion
          : religion // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable()
class _$ProfileImpl implements _Profile {
  const _$ProfileImpl(
      {@JsonKey(name: 'fullname') required this.fullName,
      @JsonKey(name: 'phone_number') this.phoneNumber,
      @JsonKey(name: 'profile_image') this.avatar,
      @JsonKey(name: 'no_identity') this.nik,
      @JsonKey(name: 'birth_date') this.dateOfBirth,
      @JsonKey(name: 'birth_place') this.placeOfBirth,
      @JsonKey(name: 'work_in') this.workPlace,
      @JsonKey(name: 'blood_type') this.bloodType,
      @JsonKey(name: 'marital_status') this.maritalStatus,
      @JsonKey(name: 'responsibleForCosts') this.insurance,
      @JsonKey(name: 'area_code') this.postCode,
      this.gender,
      this.address,
      this.nationality,
      this.religion});

  factory _$ProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileImplFromJson(json);

  @override
  @JsonKey(name: 'fullname')
  final String fullName;
  @override
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @override
  @JsonKey(name: 'profile_image')
  final String? avatar;
  @override
  @JsonKey(name: 'no_identity')
  final String? nik;
  @override
  @JsonKey(name: 'birth_date')
  final DateTime? dateOfBirth;
  @override
  @JsonKey(name: 'birth_place')
  final String? placeOfBirth;
  @override
  @JsonKey(name: 'work_in')
  final String? workPlace;
  @override
  @JsonKey(name: 'blood_type')
  final String? bloodType;
  @override
  @JsonKey(name: 'marital_status')
  final String? maritalStatus;
  @override
  @JsonKey(name: 'responsibleForCosts')
  final String? insurance;
  @override
  @JsonKey(name: 'area_code')
  final String? postCode;
  @override
  final String? gender;
  @override
  final String? address;
  @override
  final String? nationality;
  @override
  final String? religion;

  @override
  String toString() {
    return 'Profile(fullName: $fullName, phoneNumber: $phoneNumber, avatar: $avatar, nik: $nik, dateOfBirth: $dateOfBirth, placeOfBirth: $placeOfBirth, workPlace: $workPlace, bloodType: $bloodType, maritalStatus: $maritalStatus, insurance: $insurance, postCode: $postCode, gender: $gender, address: $address, nationality: $nationality, religion: $religion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileImpl &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.nik, nik) || other.nik == nik) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.placeOfBirth, placeOfBirth) ||
                other.placeOfBirth == placeOfBirth) &&
            (identical(other.workPlace, workPlace) ||
                other.workPlace == workPlace) &&
            (identical(other.bloodType, bloodType) ||
                other.bloodType == bloodType) &&
            (identical(other.maritalStatus, maritalStatus) ||
                other.maritalStatus == maritalStatus) &&
            (identical(other.insurance, insurance) ||
                other.insurance == insurance) &&
            (identical(other.postCode, postCode) ||
                other.postCode == postCode) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.nationality, nationality) ||
                other.nationality == nationality) &&
            (identical(other.religion, religion) ||
                other.religion == religion));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      fullName,
      phoneNumber,
      avatar,
      nik,
      dateOfBirth,
      placeOfBirth,
      workPlace,
      bloodType,
      maritalStatus,
      insurance,
      postCode,
      gender,
      address,
      nationality,
      religion);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileImplCopyWith<_$ProfileImpl> get copyWith =>
      __$$ProfileImplCopyWithImpl<_$ProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileImplToJson(
      this,
    );
  }
}

abstract class _Profile implements Profile {
  const factory _Profile(
      {@JsonKey(name: 'fullname') required final String fullName,
      @JsonKey(name: 'phone_number') final String? phoneNumber,
      @JsonKey(name: 'profile_image') final String? avatar,
      @JsonKey(name: 'no_identity') final String? nik,
      @JsonKey(name: 'birth_date') final DateTime? dateOfBirth,
      @JsonKey(name: 'birth_place') final String? placeOfBirth,
      @JsonKey(name: 'work_in') final String? workPlace,
      @JsonKey(name: 'blood_type') final String? bloodType,
      @JsonKey(name: 'marital_status') final String? maritalStatus,
      @JsonKey(name: 'responsibleForCosts') final String? insurance,
      @JsonKey(name: 'area_code') final String? postCode,
      final String? gender,
      final String? address,
      final String? nationality,
      final String? religion}) = _$ProfileImpl;

  factory _Profile.fromJson(Map<String, dynamic> json) = _$ProfileImpl.fromJson;

  @override
  @JsonKey(name: 'fullname')
  String get fullName;
  @override
  @JsonKey(name: 'phone_number')
  String? get phoneNumber;
  @override
  @JsonKey(name: 'profile_image')
  String? get avatar;
  @override
  @JsonKey(name: 'no_identity')
  String? get nik;
  @override
  @JsonKey(name: 'birth_date')
  DateTime? get dateOfBirth;
  @override
  @JsonKey(name: 'birth_place')
  String? get placeOfBirth;
  @override
  @JsonKey(name: 'work_in')
  String? get workPlace;
  @override
  @JsonKey(name: 'blood_type')
  String? get bloodType;
  @override
  @JsonKey(name: 'marital_status')
  String? get maritalStatus;
  @override
  @JsonKey(name: 'responsibleForCosts')
  String? get insurance;
  @override
  @JsonKey(name: 'area_code')
  String? get postCode;
  @override
  String? get gender;
  @override
  String? get address;
  @override
  String? get nationality;
  @override
  String? get religion;
  @override
  @JsonKey(ignore: true)
  _$$ProfileImplCopyWith<_$ProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
