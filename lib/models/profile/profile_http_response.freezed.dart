// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_http_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProfileHttpResponse _$ProfileHttpResponseFromJson(Map<String, dynamic> json) {
  return _ProfileHttpResponse.fromJson(json);
}

/// @nodoc
mixin _$ProfileHttpResponse {
  ProfileHttpResponseData? get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileHttpResponseCopyWith<ProfileHttpResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileHttpResponseCopyWith<$Res> {
  factory $ProfileHttpResponseCopyWith(
          ProfileHttpResponse value, $Res Function(ProfileHttpResponse) then) =
      _$ProfileHttpResponseCopyWithImpl<$Res, ProfileHttpResponse>;
  @useResult
  $Res call({ProfileHttpResponseData? data});

  $ProfileHttpResponseDataCopyWith<$Res>? get data;
}

/// @nodoc
class _$ProfileHttpResponseCopyWithImpl<$Res, $Val extends ProfileHttpResponse>
    implements $ProfileHttpResponseCopyWith<$Res> {
  _$ProfileHttpResponseCopyWithImpl(this._value, this._then);

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
              as ProfileHttpResponseData?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProfileHttpResponseDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $ProfileHttpResponseDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProfileHttpResponseImplCopyWith<$Res>
    implements $ProfileHttpResponseCopyWith<$Res> {
  factory _$$ProfileHttpResponseImplCopyWith(_$ProfileHttpResponseImpl value,
          $Res Function(_$ProfileHttpResponseImpl) then) =
      __$$ProfileHttpResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ProfileHttpResponseData? data});

  @override
  $ProfileHttpResponseDataCopyWith<$Res>? get data;
}

/// @nodoc
class __$$ProfileHttpResponseImplCopyWithImpl<$Res>
    extends _$ProfileHttpResponseCopyWithImpl<$Res, _$ProfileHttpResponseImpl>
    implements _$$ProfileHttpResponseImplCopyWith<$Res> {
  __$$ProfileHttpResponseImplCopyWithImpl(_$ProfileHttpResponseImpl _value,
      $Res Function(_$ProfileHttpResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$ProfileHttpResponseImpl(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ProfileHttpResponseData?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileHttpResponseImpl implements _ProfileHttpResponse {
  const _$ProfileHttpResponseImpl({this.data});

  factory _$ProfileHttpResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileHttpResponseImplFromJson(json);

  @override
  final ProfileHttpResponseData? data;

  @override
  String toString() {
    return 'ProfileHttpResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileHttpResponseImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileHttpResponseImplCopyWith<_$ProfileHttpResponseImpl> get copyWith =>
      __$$ProfileHttpResponseImplCopyWithImpl<_$ProfileHttpResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileHttpResponseImplToJson(
      this,
    );
  }
}

abstract class _ProfileHttpResponse implements ProfileHttpResponse {
  const factory _ProfileHttpResponse({final ProfileHttpResponseData? data}) =
      _$ProfileHttpResponseImpl;

  factory _ProfileHttpResponse.fromJson(Map<String, dynamic> json) =
      _$ProfileHttpResponseImpl.fromJson;

  @override
  ProfileHttpResponseData? get data;
  @override
  @JsonKey(ignore: true)
  _$$ProfileHttpResponseImplCopyWith<_$ProfileHttpResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProfileHttpResponseData _$ProfileHttpResponseDataFromJson(
    Map<String, dynamic> json) {
  return _ProfileHttpResponseData.fromJson(json);
}

/// @nodoc
mixin _$ProfileHttpResponseData {
  Profile get user => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileHttpResponseDataCopyWith<ProfileHttpResponseData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileHttpResponseDataCopyWith<$Res> {
  factory $ProfileHttpResponseDataCopyWith(ProfileHttpResponseData value,
          $Res Function(ProfileHttpResponseData) then) =
      _$ProfileHttpResponseDataCopyWithImpl<$Res, ProfileHttpResponseData>;
  @useResult
  $Res call({Profile user, String? token});

  $ProfileCopyWith<$Res> get user;
}

/// @nodoc
class _$ProfileHttpResponseDataCopyWithImpl<$Res,
        $Val extends ProfileHttpResponseData>
    implements $ProfileHttpResponseDataCopyWith<$Res> {
  _$ProfileHttpResponseDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? token = freezed,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as Profile,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<$Res> get user {
    return $ProfileCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProfileHttpResponseDataImplCopyWith<$Res>
    implements $ProfileHttpResponseDataCopyWith<$Res> {
  factory _$$ProfileHttpResponseDataImplCopyWith(
          _$ProfileHttpResponseDataImpl value,
          $Res Function(_$ProfileHttpResponseDataImpl) then) =
      __$$ProfileHttpResponseDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Profile user, String? token});

  @override
  $ProfileCopyWith<$Res> get user;
}

/// @nodoc
class __$$ProfileHttpResponseDataImplCopyWithImpl<$Res>
    extends _$ProfileHttpResponseDataCopyWithImpl<$Res,
        _$ProfileHttpResponseDataImpl>
    implements _$$ProfileHttpResponseDataImplCopyWith<$Res> {
  __$$ProfileHttpResponseDataImplCopyWithImpl(
      _$ProfileHttpResponseDataImpl _value,
      $Res Function(_$ProfileHttpResponseDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? token = freezed,
  }) {
    return _then(_$ProfileHttpResponseDataImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as Profile,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileHttpResponseDataImpl implements _ProfileHttpResponseData {
  const _$ProfileHttpResponseDataImpl({required this.user, this.token});

  factory _$ProfileHttpResponseDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileHttpResponseDataImplFromJson(json);

  @override
  final Profile user;
  @override
  final String? token;

  @override
  String toString() {
    return 'ProfileHttpResponseData(user: $user, token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileHttpResponseDataImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, user, token);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileHttpResponseDataImplCopyWith<_$ProfileHttpResponseDataImpl>
      get copyWith => __$$ProfileHttpResponseDataImplCopyWithImpl<
          _$ProfileHttpResponseDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileHttpResponseDataImplToJson(
      this,
    );
  }
}

abstract class _ProfileHttpResponseData implements ProfileHttpResponseData {
  const factory _ProfileHttpResponseData(
      {required final Profile user,
      final String? token}) = _$ProfileHttpResponseDataImpl;

  factory _ProfileHttpResponseData.fromJson(Map<String, dynamic> json) =
      _$ProfileHttpResponseDataImpl.fromJson;

  @override
  Profile get user;
  @override
  String? get token;
  @override
  @JsonKey(ignore: true)
  _$$ProfileHttpResponseDataImplCopyWith<_$ProfileHttpResponseDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
