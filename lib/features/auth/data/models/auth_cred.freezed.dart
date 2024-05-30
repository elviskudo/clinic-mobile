// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_cred.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthCredential {
  int? get userId => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AuthCredentialCopyWith<AuthCredential> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthCredentialCopyWith<$Res> {
  factory $AuthCredentialCopyWith(
          AuthCredential value, $Res Function(AuthCredential) then) =
      _$AuthCredentialCopyWithImpl<$Res, AuthCredential>;
  @useResult
  $Res call({int? userId, bool isVerified, String fullName});
}

/// @nodoc
class _$AuthCredentialCopyWithImpl<$Res, $Val extends AuthCredential>
    implements $AuthCredentialCopyWith<$Res> {
  _$AuthCredentialCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? isVerified = null,
    Object? fullName = null,
  }) {
    return _then(_value.copyWith(
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthCredentialImplCopyWith<$Res>
    implements $AuthCredentialCopyWith<$Res> {
  factory _$$AuthCredentialImplCopyWith(_$AuthCredentialImpl value,
          $Res Function(_$AuthCredentialImpl) then) =
      __$$AuthCredentialImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? userId, bool isVerified, String fullName});
}

/// @nodoc
class __$$AuthCredentialImplCopyWithImpl<$Res>
    extends _$AuthCredentialCopyWithImpl<$Res, _$AuthCredentialImpl>
    implements _$$AuthCredentialImplCopyWith<$Res> {
  __$$AuthCredentialImplCopyWithImpl(
      _$AuthCredentialImpl _value, $Res Function(_$AuthCredentialImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? isVerified = null,
    Object? fullName = null,
  }) {
    return _then(_$AuthCredentialImpl(
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthCredentialImpl implements _AuthCredential {
  const _$AuthCredentialImpl(
      {this.userId, required this.isVerified, required this.fullName});

  @override
  final int? userId;
  @override
  final bool isVerified;
  @override
  final String fullName;

  @override
  String toString() {
    return 'AuthCredential(userId: $userId, isVerified: $isVerified, fullName: $fullName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthCredentialImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, isVerified, fullName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthCredentialImplCopyWith<_$AuthCredentialImpl> get copyWith =>
      __$$AuthCredentialImplCopyWithImpl<_$AuthCredentialImpl>(
          this, _$identity);
}

abstract class _AuthCredential implements AuthCredential {
  const factory _AuthCredential(
      {final int? userId,
      required final bool isVerified,
      required final String fullName}) = _$AuthCredentialImpl;

  @override
  int? get userId;
  @override
  bool get isVerified;
  @override
  String get fullName;
  @override
  @JsonKey(ignore: true)
  _$$AuthCredentialImplCopyWith<_$AuthCredentialImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
