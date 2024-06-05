// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_profile_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetProfileResponse _$GetProfileResponseFromJson(Map<String, dynamic> json) {
  return _GetProfileResponse.fromJson(json);
}

/// @nodoc
mixin _$GetProfileResponse {
  GetProfileResponseData? get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetProfileResponseCopyWith<GetProfileResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetProfileResponseCopyWith<$Res> {
  factory $GetProfileResponseCopyWith(
          GetProfileResponse value, $Res Function(GetProfileResponse) then) =
      _$GetProfileResponseCopyWithImpl<$Res, GetProfileResponse>;
  @useResult
  $Res call({GetProfileResponseData? data});

  $GetProfileResponseDataCopyWith<$Res>? get data;
}

/// @nodoc
class _$GetProfileResponseCopyWithImpl<$Res, $Val extends GetProfileResponse>
    implements $GetProfileResponseCopyWith<$Res> {
  _$GetProfileResponseCopyWithImpl(this._value, this._then);

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
              as GetProfileResponseData?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GetProfileResponseDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $GetProfileResponseDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GetProfileResponseImplCopyWith<$Res>
    implements $GetProfileResponseCopyWith<$Res> {
  factory _$$GetProfileResponseImplCopyWith(_$GetProfileResponseImpl value,
          $Res Function(_$GetProfileResponseImpl) then) =
      __$$GetProfileResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({GetProfileResponseData? data});

  @override
  $GetProfileResponseDataCopyWith<$Res>? get data;
}

/// @nodoc
class __$$GetProfileResponseImplCopyWithImpl<$Res>
    extends _$GetProfileResponseCopyWithImpl<$Res, _$GetProfileResponseImpl>
    implements _$$GetProfileResponseImplCopyWith<$Res> {
  __$$GetProfileResponseImplCopyWithImpl(_$GetProfileResponseImpl _value,
      $Res Function(_$GetProfileResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$GetProfileResponseImpl(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as GetProfileResponseData?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetProfileResponseImpl implements _GetProfileResponse {
  const _$GetProfileResponseImpl({this.data});

  factory _$GetProfileResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetProfileResponseImplFromJson(json);

  @override
  final GetProfileResponseData? data;

  @override
  String toString() {
    return 'GetProfileResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetProfileResponseImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GetProfileResponseImplCopyWith<_$GetProfileResponseImpl> get copyWith =>
      __$$GetProfileResponseImplCopyWithImpl<_$GetProfileResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetProfileResponseImplToJson(
      this,
    );
  }
}

abstract class _GetProfileResponse implements GetProfileResponse {
  const factory _GetProfileResponse({final GetProfileResponseData? data}) =
      _$GetProfileResponseImpl;

  factory _GetProfileResponse.fromJson(Map<String, dynamic> json) =
      _$GetProfileResponseImpl.fromJson;

  @override
  GetProfileResponseData? get data;
  @override
  @JsonKey(ignore: true)
  _$$GetProfileResponseImplCopyWith<_$GetProfileResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GetProfileResponseData _$GetProfileResponseDataFromJson(
    Map<String, dynamic> json) {
  return _GetProfileResponseData.fromJson(json);
}

/// @nodoc
mixin _$GetProfileResponseData {
  GetProfileResponseDataUser get user => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetProfileResponseDataCopyWith<GetProfileResponseData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetProfileResponseDataCopyWith<$Res> {
  factory $GetProfileResponseDataCopyWith(GetProfileResponseData value,
          $Res Function(GetProfileResponseData) then) =
      _$GetProfileResponseDataCopyWithImpl<$Res, GetProfileResponseData>;
  @useResult
  $Res call({GetProfileResponseDataUser user});

  $GetProfileResponseDataUserCopyWith<$Res> get user;
}

/// @nodoc
class _$GetProfileResponseDataCopyWithImpl<$Res,
        $Val extends GetProfileResponseData>
    implements $GetProfileResponseDataCopyWith<$Res> {
  _$GetProfileResponseDataCopyWithImpl(this._value, this._then);

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
              as GetProfileResponseDataUser,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GetProfileResponseDataUserCopyWith<$Res> get user {
    return $GetProfileResponseDataUserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GetProfileResponseDataImplCopyWith<$Res>
    implements $GetProfileResponseDataCopyWith<$Res> {
  factory _$$GetProfileResponseDataImplCopyWith(
          _$GetProfileResponseDataImpl value,
          $Res Function(_$GetProfileResponseDataImpl) then) =
      __$$GetProfileResponseDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({GetProfileResponseDataUser user});

  @override
  $GetProfileResponseDataUserCopyWith<$Res> get user;
}

/// @nodoc
class __$$GetProfileResponseDataImplCopyWithImpl<$Res>
    extends _$GetProfileResponseDataCopyWithImpl<$Res,
        _$GetProfileResponseDataImpl>
    implements _$$GetProfileResponseDataImplCopyWith<$Res> {
  __$$GetProfileResponseDataImplCopyWithImpl(
      _$GetProfileResponseDataImpl _value,
      $Res Function(_$GetProfileResponseDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_$GetProfileResponseDataImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as GetProfileResponseDataUser,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetProfileResponseDataImpl implements _GetProfileResponseData {
  const _$GetProfileResponseDataImpl({required this.user});

  factory _$GetProfileResponseDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetProfileResponseDataImplFromJson(json);

  @override
  final GetProfileResponseDataUser user;

  @override
  String toString() {
    return 'GetProfileResponseData(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetProfileResponseDataImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GetProfileResponseDataImplCopyWith<_$GetProfileResponseDataImpl>
      get copyWith => __$$GetProfileResponseDataImplCopyWithImpl<
          _$GetProfileResponseDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetProfileResponseDataImplToJson(
      this,
    );
  }
}

abstract class _GetProfileResponseData implements GetProfileResponseData {
  const factory _GetProfileResponseData(
          {required final GetProfileResponseDataUser user}) =
      _$GetProfileResponseDataImpl;

  factory _GetProfileResponseData.fromJson(Map<String, dynamic> json) =
      _$GetProfileResponseDataImpl.fromJson;

  @override
  GetProfileResponseDataUser get user;
  @override
  @JsonKey(ignore: true)
  _$$GetProfileResponseDataImplCopyWith<_$GetProfileResponseDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

GetProfileResponseDataUser _$GetProfileResponseDataUserFromJson(
    Map<String, dynamic> json) {
  return _GetProfileResponseDataUser.fromJson(json);
}

/// @nodoc
mixin _$GetProfileResponseDataUser {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_number')
  String get phoneNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'verifikasi')
  bool get isVerified => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetProfileResponseDataUserCopyWith<GetProfileResponseDataUser>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetProfileResponseDataUserCopyWith<$Res> {
  factory $GetProfileResponseDataUserCopyWith(GetProfileResponseDataUser value,
          $Res Function(GetProfileResponseDataUser) then) =
      _$GetProfileResponseDataUserCopyWithImpl<$Res,
          GetProfileResponseDataUser>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'full_name') String fullName,
      String? image,
      String email,
      @JsonKey(name: 'phone_number') String phoneNumber,
      @JsonKey(name: 'verifikasi') bool isVerified});
}

/// @nodoc
class _$GetProfileResponseDataUserCopyWithImpl<$Res,
        $Val extends GetProfileResponseDataUser>
    implements $GetProfileResponseDataUserCopyWith<$Res> {
  _$GetProfileResponseDataUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? image = freezed,
    Object? email = null,
    Object? phoneNumber = null,
    Object? isVerified = null,
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
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetProfileResponseDataUserImplCopyWith<$Res>
    implements $GetProfileResponseDataUserCopyWith<$Res> {
  factory _$$GetProfileResponseDataUserImplCopyWith(
          _$GetProfileResponseDataUserImpl value,
          $Res Function(_$GetProfileResponseDataUserImpl) then) =
      __$$GetProfileResponseDataUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'full_name') String fullName,
      String? image,
      String email,
      @JsonKey(name: 'phone_number') String phoneNumber,
      @JsonKey(name: 'verifikasi') bool isVerified});
}

/// @nodoc
class __$$GetProfileResponseDataUserImplCopyWithImpl<$Res>
    extends _$GetProfileResponseDataUserCopyWithImpl<$Res,
        _$GetProfileResponseDataUserImpl>
    implements _$$GetProfileResponseDataUserImplCopyWith<$Res> {
  __$$GetProfileResponseDataUserImplCopyWithImpl(
      _$GetProfileResponseDataUserImpl _value,
      $Res Function(_$GetProfileResponseDataUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? image = freezed,
    Object? email = null,
    Object? phoneNumber = null,
    Object? isVerified = null,
  }) {
    return _then(_$GetProfileResponseDataUserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetProfileResponseDataUserImpl implements _GetProfileResponseDataUser {
  const _$GetProfileResponseDataUserImpl(
      {required this.id,
      @JsonKey(name: 'full_name') required this.fullName,
      this.image,
      required this.email,
      @JsonKey(name: 'phone_number') required this.phoneNumber,
      @JsonKey(name: 'verifikasi') required this.isVerified});

  factory _$GetProfileResponseDataUserImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$GetProfileResponseDataUserImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @override
  final String? image;
  @override
  final String email;
  @override
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  @override
  @JsonKey(name: 'verifikasi')
  final bool isVerified;

  @override
  String toString() {
    return 'GetProfileResponseDataUser(id: $id, fullName: $fullName, image: $image, email: $email, phoneNumber: $phoneNumber, isVerified: $isVerified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetProfileResponseDataUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, fullName, image, email, phoneNumber, isVerified);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GetProfileResponseDataUserImplCopyWith<_$GetProfileResponseDataUserImpl>
      get copyWith => __$$GetProfileResponseDataUserImplCopyWithImpl<
          _$GetProfileResponseDataUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetProfileResponseDataUserImplToJson(
      this,
    );
  }
}

abstract class _GetProfileResponseDataUser
    implements GetProfileResponseDataUser {
  const factory _GetProfileResponseDataUser(
          {required final int id,
          @JsonKey(name: 'full_name') required final String fullName,
          final String? image,
          required final String email,
          @JsonKey(name: 'phone_number') required final String phoneNumber,
          @JsonKey(name: 'verifikasi') required final bool isVerified}) =
      _$GetProfileResponseDataUserImpl;

  factory _GetProfileResponseDataUser.fromJson(Map<String, dynamic> json) =
      _$GetProfileResponseDataUserImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'full_name')
  String get fullName;
  @override
  String? get image;
  @override
  String get email;
  @override
  @JsonKey(name: 'phone_number')
  String get phoneNumber;
  @override
  @JsonKey(name: 'verifikasi')
  bool get isVerified;
  @override
  @JsonKey(ignore: true)
  _$$GetProfileResponseDataUserImplCopyWith<_$GetProfileResponseDataUserImpl>
      get copyWith => throw _privateConstructorUsedError;
}
