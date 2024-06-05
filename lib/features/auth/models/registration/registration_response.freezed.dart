// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegistrationResponse _$RegistrationResponseFromJson(Map<String, dynamic> json) {
  return _RegistrationResponse.fromJson(json);
}

/// @nodoc
mixin _$RegistrationResponse {
  RegistrationResponseData? get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RegistrationResponseCopyWith<RegistrationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationResponseCopyWith<$Res> {
  factory $RegistrationResponseCopyWith(RegistrationResponse value,
          $Res Function(RegistrationResponse) then) =
      _$RegistrationResponseCopyWithImpl<$Res, RegistrationResponse>;
  @useResult
  $Res call({RegistrationResponseData? data});

  $RegistrationResponseDataCopyWith<$Res>? get data;
}

/// @nodoc
class _$RegistrationResponseCopyWithImpl<$Res,
        $Val extends RegistrationResponse>
    implements $RegistrationResponseCopyWith<$Res> {
  _$RegistrationResponseCopyWithImpl(this._value, this._then);

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
              as RegistrationResponseData?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RegistrationResponseDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $RegistrationResponseDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RegistrationResponseImplCopyWith<$Res>
    implements $RegistrationResponseCopyWith<$Res> {
  factory _$$RegistrationResponseImplCopyWith(_$RegistrationResponseImpl value,
          $Res Function(_$RegistrationResponseImpl) then) =
      __$$RegistrationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({RegistrationResponseData? data});

  @override
  $RegistrationResponseDataCopyWith<$Res>? get data;
}

/// @nodoc
class __$$RegistrationResponseImplCopyWithImpl<$Res>
    extends _$RegistrationResponseCopyWithImpl<$Res, _$RegistrationResponseImpl>
    implements _$$RegistrationResponseImplCopyWith<$Res> {
  __$$RegistrationResponseImplCopyWithImpl(_$RegistrationResponseImpl _value,
      $Res Function(_$RegistrationResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$RegistrationResponseImpl(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as RegistrationResponseData?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationResponseImpl implements _RegistrationResponse {
  const _$RegistrationResponseImpl({this.data});

  factory _$RegistrationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegistrationResponseImplFromJson(json);

  @override
  final RegistrationResponseData? data;

  @override
  String toString() {
    return 'RegistrationResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationResponseImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationResponseImplCopyWith<_$RegistrationResponseImpl>
      get copyWith =>
          __$$RegistrationResponseImplCopyWithImpl<_$RegistrationResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistrationResponseImplToJson(
      this,
    );
  }
}

abstract class _RegistrationResponse implements RegistrationResponse {
  const factory _RegistrationResponse({final RegistrationResponseData? data}) =
      _$RegistrationResponseImpl;

  factory _RegistrationResponse.fromJson(Map<String, dynamic> json) =
      _$RegistrationResponseImpl.fromJson;

  @override
  RegistrationResponseData? get data;
  @override
  @JsonKey(ignore: true)
  _$$RegistrationResponseImplCopyWith<_$RegistrationResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RegistrationResponseData _$RegistrationResponseDataFromJson(
    Map<String, dynamic> json) {
  return _RegistrationResponseData.fromJson(json);
}

/// @nodoc
mixin _$RegistrationResponseData {
  RegistrationResponseDataUser get user => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RegistrationResponseDataCopyWith<RegistrationResponseData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationResponseDataCopyWith<$Res> {
  factory $RegistrationResponseDataCopyWith(RegistrationResponseData value,
          $Res Function(RegistrationResponseData) then) =
      _$RegistrationResponseDataCopyWithImpl<$Res, RegistrationResponseData>;
  @useResult
  $Res call({RegistrationResponseDataUser user});

  $RegistrationResponseDataUserCopyWith<$Res> get user;
}

/// @nodoc
class _$RegistrationResponseDataCopyWithImpl<$Res,
        $Val extends RegistrationResponseData>
    implements $RegistrationResponseDataCopyWith<$Res> {
  _$RegistrationResponseDataCopyWithImpl(this._value, this._then);

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
              as RegistrationResponseDataUser,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RegistrationResponseDataUserCopyWith<$Res> get user {
    return $RegistrationResponseDataUserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RegistrationResponseDataImplCopyWith<$Res>
    implements $RegistrationResponseDataCopyWith<$Res> {
  factory _$$RegistrationResponseDataImplCopyWith(
          _$RegistrationResponseDataImpl value,
          $Res Function(_$RegistrationResponseDataImpl) then) =
      __$$RegistrationResponseDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({RegistrationResponseDataUser user});

  @override
  $RegistrationResponseDataUserCopyWith<$Res> get user;
}

/// @nodoc
class __$$RegistrationResponseDataImplCopyWithImpl<$Res>
    extends _$RegistrationResponseDataCopyWithImpl<$Res,
        _$RegistrationResponseDataImpl>
    implements _$$RegistrationResponseDataImplCopyWith<$Res> {
  __$$RegistrationResponseDataImplCopyWithImpl(
      _$RegistrationResponseDataImpl _value,
      $Res Function(_$RegistrationResponseDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_$RegistrationResponseDataImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as RegistrationResponseDataUser,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationResponseDataImpl implements _RegistrationResponseData {
  const _$RegistrationResponseDataImpl({required this.user});

  factory _$RegistrationResponseDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegistrationResponseDataImplFromJson(json);

  @override
  final RegistrationResponseDataUser user;

  @override
  String toString() {
    return 'RegistrationResponseData(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationResponseDataImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationResponseDataImplCopyWith<_$RegistrationResponseDataImpl>
      get copyWith => __$$RegistrationResponseDataImplCopyWithImpl<
          _$RegistrationResponseDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistrationResponseDataImplToJson(
      this,
    );
  }
}

abstract class _RegistrationResponseData implements RegistrationResponseData {
  const factory _RegistrationResponseData(
          {required final RegistrationResponseDataUser user}) =
      _$RegistrationResponseDataImpl;

  factory _RegistrationResponseData.fromJson(Map<String, dynamic> json) =
      _$RegistrationResponseDataImpl.fromJson;

  @override
  RegistrationResponseDataUser get user;
  @override
  @JsonKey(ignore: true)
  _$$RegistrationResponseDataImplCopyWith<_$RegistrationResponseDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RegistrationResponseDataUser _$RegistrationResponseDataUserFromJson(
    Map<String, dynamic> json) {
  return _RegistrationResponseDataUser.fromJson(json);
}

/// @nodoc
mixin _$RegistrationResponseDataUser {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'fullname')
  String get fullName => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RegistrationResponseDataUserCopyWith<RegistrationResponseDataUser>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationResponseDataUserCopyWith<$Res> {
  factory $RegistrationResponseDataUserCopyWith(
          RegistrationResponseDataUser value,
          $Res Function(RegistrationResponseDataUser) then) =
      _$RegistrationResponseDataUserCopyWithImpl<$Res,
          RegistrationResponseDataUser>;
  @useResult
  $Res call({int id, @JsonKey(name: 'fullname') String fullName, String token});
}

/// @nodoc
class _$RegistrationResponseDataUserCopyWithImpl<$Res,
        $Val extends RegistrationResponseDataUser>
    implements $RegistrationResponseDataUserCopyWith<$Res> {
  _$RegistrationResponseDataUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? token = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegistrationResponseDataUserImplCopyWith<$Res>
    implements $RegistrationResponseDataUserCopyWith<$Res> {
  factory _$$RegistrationResponseDataUserImplCopyWith(
          _$RegistrationResponseDataUserImpl value,
          $Res Function(_$RegistrationResponseDataUserImpl) then) =
      __$$RegistrationResponseDataUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, @JsonKey(name: 'fullname') String fullName, String token});
}

/// @nodoc
class __$$RegistrationResponseDataUserImplCopyWithImpl<$Res>
    extends _$RegistrationResponseDataUserCopyWithImpl<$Res,
        _$RegistrationResponseDataUserImpl>
    implements _$$RegistrationResponseDataUserImplCopyWith<$Res> {
  __$$RegistrationResponseDataUserImplCopyWithImpl(
      _$RegistrationResponseDataUserImpl _value,
      $Res Function(_$RegistrationResponseDataUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? token = null,
  }) {
    return _then(_$RegistrationResponseDataUserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationResponseDataUserImpl
    implements _RegistrationResponseDataUser {
  const _$RegistrationResponseDataUserImpl(
      {required this.id,
      @JsonKey(name: 'fullname') required this.fullName,
      required this.token});

  factory _$RegistrationResponseDataUserImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$RegistrationResponseDataUserImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'fullname')
  final String fullName;
  @override
  final String token;

  @override
  String toString() {
    return 'RegistrationResponseDataUser(id: $id, fullName: $fullName, token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationResponseDataUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, fullName, token);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationResponseDataUserImplCopyWith<
          _$RegistrationResponseDataUserImpl>
      get copyWith => __$$RegistrationResponseDataUserImplCopyWithImpl<
          _$RegistrationResponseDataUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistrationResponseDataUserImplToJson(
      this,
    );
  }
}

abstract class _RegistrationResponseDataUser
    implements RegistrationResponseDataUser {
  const factory _RegistrationResponseDataUser(
      {required final int id,
      @JsonKey(name: 'fullname') required final String fullName,
      required final String token}) = _$RegistrationResponseDataUserImpl;

  factory _RegistrationResponseDataUser.fromJson(Map<String, dynamic> json) =
      _$RegistrationResponseDataUserImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'fullname')
  String get fullName;
  @override
  String get token;
  @override
  @JsonKey(ignore: true)
  _$$RegistrationResponseDataUserImplCopyWith<
          _$RegistrationResponseDataUserImpl>
      get copyWith => throw _privateConstructorUsedError;
}
