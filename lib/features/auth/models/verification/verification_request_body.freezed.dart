// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verification_request_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VerificationRequestBody _$VerificationRequestBodyFromJson(
    Map<String, dynamic> json) {
  return _VerificationRequestBody.fromJson(json);
}

/// @nodoc
mixin _$VerificationRequestBody {
  @JsonKey(name: 'kode_otp')
  String get otpCode => throw _privateConstructorUsedError;

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
  $Res call({@JsonKey(name: 'kode_otp') String otpCode});
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
    Object? otpCode = null,
  }) {
    return _then(_value.copyWith(
      otpCode: null == otpCode
          ? _value.otpCode
          : otpCode // ignore: cast_nullable_to_non_nullable
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
  $Res call({@JsonKey(name: 'kode_otp') String otpCode});
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
    Object? otpCode = null,
  }) {
    return _then(_$VerificationRequestBodyImpl(
      otpCode: null == otpCode
          ? _value.otpCode
          : otpCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerificationRequestBodyImpl implements _VerificationRequestBody {
  const _$VerificationRequestBodyImpl(
      {@JsonKey(name: 'kode_otp') required this.otpCode});

  factory _$VerificationRequestBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerificationRequestBodyImplFromJson(json);

  @override
  @JsonKey(name: 'kode_otp')
  final String otpCode;

  @override
  String toString() {
    return 'VerificationRequestBody(otpCode: $otpCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationRequestBodyImpl &&
            (identical(other.otpCode, otpCode) || other.otpCode == otpCode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, otpCode);

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
          {@JsonKey(name: 'kode_otp') required final String otpCode}) =
      _$VerificationRequestBodyImpl;

  factory _VerificationRequestBody.fromJson(Map<String, dynamic> json) =
      _$VerificationRequestBodyImpl.fromJson;

  @override
  @JsonKey(name: 'kode_otp')
  String get otpCode;
  @override
  @JsonKey(ignore: true)
  _$$VerificationRequestBodyImplCopyWith<_$VerificationRequestBodyImpl>
      get copyWith => throw _privateConstructorUsedError;
}
