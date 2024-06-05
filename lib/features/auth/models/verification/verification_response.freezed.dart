// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verification_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VerificationResponse _$VerificationResponseFromJson(Map<String, dynamic> json) {
  return _VerificationResponse.fromJson(json);
}

/// @nodoc
mixin _$VerificationResponse {
  VerificationResponseData? get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VerificationResponseCopyWith<VerificationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationResponseCopyWith<$Res> {
  factory $VerificationResponseCopyWith(VerificationResponse value,
          $Res Function(VerificationResponse) then) =
      _$VerificationResponseCopyWithImpl<$Res, VerificationResponse>;
  @useResult
  $Res call({VerificationResponseData? data});

  $VerificationResponseDataCopyWith<$Res>? get data;
}

/// @nodoc
class _$VerificationResponseCopyWithImpl<$Res,
        $Val extends VerificationResponse>
    implements $VerificationResponseCopyWith<$Res> {
  _$VerificationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as VerificationResponseData?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $VerificationResponseDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $VerificationResponseDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VerificationResponseImplCopyWith<$Res>
    implements $VerificationResponseCopyWith<$Res> {
  factory _$$VerificationResponseImplCopyWith(_$VerificationResponseImpl value,
          $Res Function(_$VerificationResponseImpl) then) =
      __$$VerificationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({VerificationResponseData? data});

  @override
  $VerificationResponseDataCopyWith<$Res>? get data;
}

/// @nodoc
class __$$VerificationResponseImplCopyWithImpl<$Res>
    extends _$VerificationResponseCopyWithImpl<$Res, _$VerificationResponseImpl>
    implements _$$VerificationResponseImplCopyWith<$Res> {
  __$$VerificationResponseImplCopyWithImpl(_$VerificationResponseImpl _value,
      $Res Function(_$VerificationResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$VerificationResponseImpl(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as VerificationResponseData?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerificationResponseImpl implements _VerificationResponse {
  const _$VerificationResponseImpl({this.data});

  factory _$VerificationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerificationResponseImplFromJson(json);

  @override
  final VerificationResponseData? data;

  @override
  String toString() {
    return 'VerificationResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationResponseImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationResponseImplCopyWith<_$VerificationResponseImpl>
      get copyWith =>
          __$$VerificationResponseImplCopyWithImpl<_$VerificationResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerificationResponseImplToJson(
      this,
    );
  }
}

abstract class _VerificationResponse implements VerificationResponse {
  const factory _VerificationResponse({final VerificationResponseData? data}) =
      _$VerificationResponseImpl;

  factory _VerificationResponse.fromJson(Map<String, dynamic> json) =
      _$VerificationResponseImpl.fromJson;

  @override
  VerificationResponseData? get data;
  @override
  @JsonKey(ignore: true)
  _$$VerificationResponseImplCopyWith<_$VerificationResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

VerificationResponseData _$VerificationResponseDataFromJson(
    Map<String, dynamic> json) {
  return _VerificationResponseData.fromJson(json);
}

/// @nodoc
mixin _$VerificationResponseData {
  VerificationResponseDataUser get user => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VerificationResponseDataCopyWith<VerificationResponseData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationResponseDataCopyWith<$Res> {
  factory $VerificationResponseDataCopyWith(VerificationResponseData value,
          $Res Function(VerificationResponseData) then) =
      _$VerificationResponseDataCopyWithImpl<$Res, VerificationResponseData>;
  @useResult
  $Res call({VerificationResponseDataUser user});

  $VerificationResponseDataUserCopyWith<$Res> get user;
}

/// @nodoc
class _$VerificationResponseDataCopyWithImpl<$Res,
        $Val extends VerificationResponseData>
    implements $VerificationResponseDataCopyWith<$Res> {
  _$VerificationResponseDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as VerificationResponseDataUser,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $VerificationResponseDataUserCopyWith<$Res> get user {
    return $VerificationResponseDataUserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VerificationResponseDataImplCopyWith<$Res>
    implements $VerificationResponseDataCopyWith<$Res> {
  factory _$$VerificationResponseDataImplCopyWith(
          _$VerificationResponseDataImpl value,
          $Res Function(_$VerificationResponseDataImpl) then) =
      __$$VerificationResponseDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({VerificationResponseDataUser user});

  @override
  $VerificationResponseDataUserCopyWith<$Res> get user;
}

/// @nodoc
class __$$VerificationResponseDataImplCopyWithImpl<$Res>
    extends _$VerificationResponseDataCopyWithImpl<$Res,
        _$VerificationResponseDataImpl>
    implements _$$VerificationResponseDataImplCopyWith<$Res> {
  __$$VerificationResponseDataImplCopyWithImpl(
      _$VerificationResponseDataImpl _value,
      $Res Function(_$VerificationResponseDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_$VerificationResponseDataImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as VerificationResponseDataUser,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerificationResponseDataImpl implements _VerificationResponseData {
  const _$VerificationResponseDataImpl({required this.user});

  factory _$VerificationResponseDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerificationResponseDataImplFromJson(json);

  @override
  final VerificationResponseDataUser user;

  @override
  String toString() {
    return 'VerificationResponseData(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationResponseDataImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationResponseDataImplCopyWith<_$VerificationResponseDataImpl>
      get copyWith => __$$VerificationResponseDataImplCopyWithImpl<
          _$VerificationResponseDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerificationResponseDataImplToJson(
      this,
    );
  }
}

abstract class _VerificationResponseData implements VerificationResponseData {
  const factory _VerificationResponseData(
          {required final VerificationResponseDataUser user}) =
      _$VerificationResponseDataImpl;

  factory _VerificationResponseData.fromJson(Map<String, dynamic> json) =
      _$VerificationResponseDataImpl.fromJson;

  @override
  VerificationResponseDataUser get user;
  @override
  @JsonKey(ignore: true)
  _$$VerificationResponseDataImplCopyWith<_$VerificationResponseDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

VerificationResponseDataUser _$VerificationResponseDataUserFromJson(
    Map<String, dynamic> json) {
  return _VerificationResponseDataUser.fromJson(json);
}

/// @nodoc
mixin _$VerificationResponseDataUser {
  String get token => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VerificationResponseDataUserCopyWith<VerificationResponseDataUser>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationResponseDataUserCopyWith<$Res> {
  factory $VerificationResponseDataUserCopyWith(
          VerificationResponseDataUser value,
          $Res Function(VerificationResponseDataUser) then) =
      _$VerificationResponseDataUserCopyWithImpl<$Res,
          VerificationResponseDataUser>;
  @useResult
  $Res call({String token});
}

/// @nodoc
class _$VerificationResponseDataUserCopyWithImpl<$Res,
        $Val extends VerificationResponseDataUser>
    implements $VerificationResponseDataUserCopyWith<$Res> {
  _$VerificationResponseDataUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VerificationResponseDataUserImplCopyWith<$Res>
    implements $VerificationResponseDataUserCopyWith<$Res> {
  factory _$$VerificationResponseDataUserImplCopyWith(
          _$VerificationResponseDataUserImpl value,
          $Res Function(_$VerificationResponseDataUserImpl) then) =
      __$$VerificationResponseDataUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token});
}

/// @nodoc
class __$$VerificationResponseDataUserImplCopyWithImpl<$Res>
    extends _$VerificationResponseDataUserCopyWithImpl<$Res,
        _$VerificationResponseDataUserImpl>
    implements _$$VerificationResponseDataUserImplCopyWith<$Res> {
  __$$VerificationResponseDataUserImplCopyWithImpl(
      _$VerificationResponseDataUserImpl _value,
      $Res Function(_$VerificationResponseDataUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
  }) {
    return _then(_$VerificationResponseDataUserImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerificationResponseDataUserImpl
    implements _VerificationResponseDataUser {
  const _$VerificationResponseDataUserImpl({required this.token});

  factory _$VerificationResponseDataUserImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$VerificationResponseDataUserImplFromJson(json);

  @override
  final String token;

  @override
  String toString() {
    return 'VerificationResponseDataUser(token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationResponseDataUserImpl &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, token);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationResponseDataUserImplCopyWith<
          _$VerificationResponseDataUserImpl>
      get copyWith => __$$VerificationResponseDataUserImplCopyWithImpl<
          _$VerificationResponseDataUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerificationResponseDataUserImplToJson(
      this,
    );
  }
}

abstract class _VerificationResponseDataUser
    implements VerificationResponseDataUser {
  const factory _VerificationResponseDataUser({required final String token}) =
      _$VerificationResponseDataUserImpl;

  factory _VerificationResponseDataUser.fromJson(Map<String, dynamic> json) =
      _$VerificationResponseDataUserImpl.fromJson;

  @override
  String get token;
  @override
  @JsonKey(ignore: true)
  _$$VerificationResponseDataUserImplCopyWith<
          _$VerificationResponseDataUserImpl>
      get copyWith => throw _privateConstructorUsedError;
}
