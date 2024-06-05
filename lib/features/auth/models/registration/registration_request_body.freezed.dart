// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_request_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegistrationRequestBody _$RegistrationRequestBodyFromJson(
    Map<String, dynamic> json) {
  return _RegistrationRequestBody.fromJson(json);
}

/// @nodoc
mixin _$RegistrationRequestBody {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  @JsonKey(name: 'fullname')
  String get fullName => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_number')
  String get phoneNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RegistrationRequestBodyCopyWith<RegistrationRequestBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationRequestBodyCopyWith<$Res> {
  factory $RegistrationRequestBodyCopyWith(RegistrationRequestBody value,
          $Res Function(RegistrationRequestBody) then) =
      _$RegistrationRequestBodyCopyWithImpl<$Res, RegistrationRequestBody>;
  @useResult
  $Res call(
      {String email,
      String password,
      @JsonKey(name: 'fullname') String fullName,
      @JsonKey(name: 'phone_number') String phoneNumber});
}

/// @nodoc
class _$RegistrationRequestBodyCopyWithImpl<$Res,
        $Val extends RegistrationRequestBody>
    implements $RegistrationRequestBodyCopyWith<$Res> {
  _$RegistrationRequestBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? fullName = null,
    Object? phoneNumber = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegistrationRequestBodyImplCopyWith<$Res>
    implements $RegistrationRequestBodyCopyWith<$Res> {
  factory _$$RegistrationRequestBodyImplCopyWith(
          _$RegistrationRequestBodyImpl value,
          $Res Function(_$RegistrationRequestBodyImpl) then) =
      __$$RegistrationRequestBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String email,
      String password,
      @JsonKey(name: 'fullname') String fullName,
      @JsonKey(name: 'phone_number') String phoneNumber});
}

/// @nodoc
class __$$RegistrationRequestBodyImplCopyWithImpl<$Res>
    extends _$RegistrationRequestBodyCopyWithImpl<$Res,
        _$RegistrationRequestBodyImpl>
    implements _$$RegistrationRequestBodyImplCopyWith<$Res> {
  __$$RegistrationRequestBodyImplCopyWithImpl(
      _$RegistrationRequestBodyImpl _value,
      $Res Function(_$RegistrationRequestBodyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? fullName = null,
    Object? phoneNumber = null,
  }) {
    return _then(_$RegistrationRequestBodyImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationRequestBodyImpl implements _RegistrationRequestBody {
  const _$RegistrationRequestBodyImpl(
      {required this.email,
      required this.password,
      @JsonKey(name: 'fullname') required this.fullName,
      @JsonKey(name: 'phone_number') required this.phoneNumber});

  factory _$RegistrationRequestBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegistrationRequestBodyImplFromJson(json);

  @override
  final String email;
  @override
  final String password;
  @override
  @JsonKey(name: 'fullname')
  final String fullName;
  @override
  @JsonKey(name: 'phone_number')
  final String phoneNumber;

  @override
  String toString() {
    return 'RegistrationRequestBody(email: $email, password: $password, fullName: $fullName, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationRequestBodyImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, email, password, fullName, phoneNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationRequestBodyImplCopyWith<_$RegistrationRequestBodyImpl>
      get copyWith => __$$RegistrationRequestBodyImplCopyWithImpl<
          _$RegistrationRequestBodyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistrationRequestBodyImplToJson(
      this,
    );
  }
}

abstract class _RegistrationRequestBody implements RegistrationRequestBody {
  const factory _RegistrationRequestBody(
          {required final String email,
          required final String password,
          @JsonKey(name: 'fullname') required final String fullName,
          @JsonKey(name: 'phone_number') required final String phoneNumber}) =
      _$RegistrationRequestBodyImpl;

  factory _RegistrationRequestBody.fromJson(Map<String, dynamic> json) =
      _$RegistrationRequestBodyImpl.fromJson;

  @override
  String get email;
  @override
  String get password;
  @override
  @JsonKey(name: 'fullname')
  String get fullName;
  @override
  @JsonKey(name: 'phone_number')
  String get phoneNumber;
  @override
  @JsonKey(ignore: true)
  _$$RegistrationRequestBodyImplCopyWith<_$RegistrationRequestBodyImpl>
      get copyWith => throw _privateConstructorUsedError;
}
