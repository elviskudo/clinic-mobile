// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SigninRequestBody _$SigninRequestBodyFromJson(Map<String, dynamic> json) {
  return _SigninRequestBody.fromJson(json);
}

/// @nodoc
mixin _$SigninRequestBody {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SigninRequestBodyCopyWith<SigninRequestBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SigninRequestBodyCopyWith<$Res> {
  factory $SigninRequestBodyCopyWith(
          SigninRequestBody value, $Res Function(SigninRequestBody) then) =
      _$SigninRequestBodyCopyWithImpl<$Res, SigninRequestBody>;
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class _$SigninRequestBodyCopyWithImpl<$Res, $Val extends SigninRequestBody>
    implements $SigninRequestBodyCopyWith<$Res> {
  _$SigninRequestBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SigninRequestBodyImplCopyWith<$Res>
    implements $SigninRequestBodyCopyWith<$Res> {
  factory _$$SigninRequestBodyImplCopyWith(_$SigninRequestBodyImpl value,
          $Res Function(_$SigninRequestBodyImpl) then) =
      __$$SigninRequestBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class __$$SigninRequestBodyImplCopyWithImpl<$Res>
    extends _$SigninRequestBodyCopyWithImpl<$Res, _$SigninRequestBodyImpl>
    implements _$$SigninRequestBodyImplCopyWith<$Res> {
  __$$SigninRequestBodyImplCopyWithImpl(_$SigninRequestBodyImpl _value,
      $Res Function(_$SigninRequestBodyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
  }) {
    return _then(_$SigninRequestBodyImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SigninRequestBodyImpl implements _SigninRequestBody {
  const _$SigninRequestBodyImpl({required this.email, required this.password});

  factory _$SigninRequestBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$SigninRequestBodyImplFromJson(json);

  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'SigninRequestBody(email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SigninRequestBodyImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, email, password);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SigninRequestBodyImplCopyWith<_$SigninRequestBodyImpl> get copyWith =>
      __$$SigninRequestBodyImplCopyWithImpl<_$SigninRequestBodyImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SigninRequestBodyImplToJson(
      this,
    );
  }
}

abstract class _SigninRequestBody implements SigninRequestBody {
  const factory _SigninRequestBody(
      {required final String email,
      required final String password}) = _$SigninRequestBodyImpl;

  factory _SigninRequestBody.fromJson(Map<String, dynamic> json) =
      _$SigninRequestBodyImpl.fromJson;

  @override
  String get email;
  @override
  String get password;
  @override
  @JsonKey(ignore: true)
  _$$SigninRequestBodyImplCopyWith<_$SigninRequestBodyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SignupRequestBody _$SignupRequestBodyFromJson(Map<String, dynamic> json) {
  return _SignupRequestBody.fromJson(json);
}

/// @nodoc
mixin _$SignupRequestBody {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  @JsonKey(name: 'fullname')
  String get fullName => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_number')
  String get phoneNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SignupRequestBodyCopyWith<SignupRequestBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignupRequestBodyCopyWith<$Res> {
  factory $SignupRequestBodyCopyWith(
          SignupRequestBody value, $Res Function(SignupRequestBody) then) =
      _$SignupRequestBodyCopyWithImpl<$Res, SignupRequestBody>;
  @useResult
  $Res call(
      {String email,
      String password,
      @JsonKey(name: 'fullname') String fullName,
      @JsonKey(name: 'phone_number') String phoneNumber});
}

/// @nodoc
class _$SignupRequestBodyCopyWithImpl<$Res, $Val extends SignupRequestBody>
    implements $SignupRequestBodyCopyWith<$Res> {
  _$SignupRequestBodyCopyWithImpl(this._value, this._then);

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
abstract class _$$SignupRequestBodyImplCopyWith<$Res>
    implements $SignupRequestBodyCopyWith<$Res> {
  factory _$$SignupRequestBodyImplCopyWith(_$SignupRequestBodyImpl value,
          $Res Function(_$SignupRequestBodyImpl) then) =
      __$$SignupRequestBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String email,
      String password,
      @JsonKey(name: 'fullname') String fullName,
      @JsonKey(name: 'phone_number') String phoneNumber});
}

/// @nodoc
class __$$SignupRequestBodyImplCopyWithImpl<$Res>
    extends _$SignupRequestBodyCopyWithImpl<$Res, _$SignupRequestBodyImpl>
    implements _$$SignupRequestBodyImplCopyWith<$Res> {
  __$$SignupRequestBodyImplCopyWithImpl(_$SignupRequestBodyImpl _value,
      $Res Function(_$SignupRequestBodyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? fullName = null,
    Object? phoneNumber = null,
  }) {
    return _then(_$SignupRequestBodyImpl(
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
class _$SignupRequestBodyImpl implements _SignupRequestBody {
  const _$SignupRequestBodyImpl(
      {required this.email,
      required this.password,
      @JsonKey(name: 'fullname') required this.fullName,
      @JsonKey(name: 'phone_number') required this.phoneNumber});

  factory _$SignupRequestBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$SignupRequestBodyImplFromJson(json);

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
    return 'SignupRequestBody(email: $email, password: $password, fullName: $fullName, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignupRequestBodyImpl &&
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
  _$$SignupRequestBodyImplCopyWith<_$SignupRequestBodyImpl> get copyWith =>
      __$$SignupRequestBodyImplCopyWithImpl<_$SignupRequestBodyImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SignupRequestBodyImplToJson(
      this,
    );
  }
}

abstract class _SignupRequestBody implements SignupRequestBody {
  const factory _SignupRequestBody(
          {required final String email,
          required final String password,
          @JsonKey(name: 'fullname') required final String fullName,
          @JsonKey(name: 'phone_number') required final String phoneNumber}) =
      _$SignupRequestBodyImpl;

  factory _SignupRequestBody.fromJson(Map<String, dynamic> json) =
      _$SignupRequestBodyImpl.fromJson;

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
  _$$SignupRequestBodyImplCopyWith<_$SignupRequestBodyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VerificationRequestBody _$VerificationRequestBodyFromJson(
    Map<String, dynamic> json) {
  return _VerificationRequestBody.fromJson(json);
}

/// @nodoc
mixin _$VerificationRequestBody {
  @JsonKey(name: 'kode_otp')
  String get code => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VerificationRequestBodyCopyWith<VerificationRequestBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationRequestBodyCopyWith<$Res> {
  factory $VerificationRequestBodyCopyWith(VerificationRequestBody value,
          $Res Function(VerificationRequestBody) then) =
      _$VerificationRequestBodyCopyWithImpl<$Res, VerificationRequestBody>;
  @useResult
  $Res call({@JsonKey(name: 'kode_otp') String code});
}

/// @nodoc
class _$VerificationRequestBodyCopyWithImpl<$Res,
        $Val extends VerificationRequestBody>
    implements $VerificationRequestBodyCopyWith<$Res> {
  _$VerificationRequestBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VerificationRequestBodyImplCopyWith<$Res>
    implements $VerificationRequestBodyCopyWith<$Res> {
  factory _$$VerificationRequestBodyImplCopyWith(
          _$VerificationRequestBodyImpl value,
          $Res Function(_$VerificationRequestBodyImpl) then) =
      __$$VerificationRequestBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'kode_otp') String code});
}

/// @nodoc
class __$$VerificationRequestBodyImplCopyWithImpl<$Res>
    extends _$VerificationRequestBodyCopyWithImpl<$Res,
        _$VerificationRequestBodyImpl>
    implements _$$VerificationRequestBodyImplCopyWith<$Res> {
  __$$VerificationRequestBodyImplCopyWithImpl(
      _$VerificationRequestBodyImpl _value,
      $Res Function(_$VerificationRequestBodyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
  }) {
    return _then(_$VerificationRequestBodyImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerificationRequestBodyImpl implements _VerificationRequestBody {
  const _$VerificationRequestBodyImpl(
      {@JsonKey(name: 'kode_otp') required this.code});

  factory _$VerificationRequestBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerificationRequestBodyImplFromJson(json);

  @override
  @JsonKey(name: 'kode_otp')
  final String code;

  @override
  String toString() {
    return 'VerificationRequestBody(code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationRequestBodyImpl &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, code);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationRequestBodyImplCopyWith<_$VerificationRequestBodyImpl>
      get copyWith => __$$VerificationRequestBodyImplCopyWithImpl<
          _$VerificationRequestBodyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerificationRequestBodyImplToJson(
      this,
    );
  }
}

abstract class _VerificationRequestBody implements VerificationRequestBody {
  const factory _VerificationRequestBody(
          {@JsonKey(name: 'kode_otp') required final String code}) =
      _$VerificationRequestBodyImpl;

  factory _VerificationRequestBody.fromJson(Map<String, dynamic> json) =
      _$VerificationRequestBodyImpl.fromJson;

  @override
  @JsonKey(name: 'kode_otp')
  String get code;
  @override
  @JsonKey(ignore: true)
  _$$VerificationRequestBodyImplCopyWith<_$VerificationRequestBodyImpl>
      get copyWith => throw _privateConstructorUsedError;
}
