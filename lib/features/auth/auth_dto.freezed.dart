// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthDTO _$AuthDTOFromJson(Map<String, dynamic> json) {
  return _AuthDTO.fromJson(json);
}

/// @nodoc
mixin _$AuthDTO {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  Role get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_verified')
  bool get isVerified => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthDTOCopyWith<AuthDTO> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthDTOCopyWith<$Res> {
  factory $AuthDTOCopyWith(AuthDTO value, $Res Function(AuthDTO) then) =
      _$AuthDTOCopyWithImpl<$Res, AuthDTO>;
  @useResult
  $Res call(
      {String id,
      String email,
      Role role,
      @JsonKey(name: 'is_verified') bool isVerified});

  $RoleCopyWith<$Res> get role;
}

/// @nodoc
class _$AuthDTOCopyWithImpl<$Res, $Val extends AuthDTO>
    implements $AuthDTOCopyWith<$Res> {
  _$AuthDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? role = null,
    Object? isVerified = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as Role,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RoleCopyWith<$Res> get role {
    return $RoleCopyWith<$Res>(_value.role, (value) {
      return _then(_value.copyWith(role: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthDTOImplCopyWith<$Res> implements $AuthDTOCopyWith<$Res> {
  factory _$$AuthDTOImplCopyWith(
          _$AuthDTOImpl value, $Res Function(_$AuthDTOImpl) then) =
      __$$AuthDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      Role role,
      @JsonKey(name: 'is_verified') bool isVerified});

  @override
  $RoleCopyWith<$Res> get role;
}

/// @nodoc
class __$$AuthDTOImplCopyWithImpl<$Res>
    extends _$AuthDTOCopyWithImpl<$Res, _$AuthDTOImpl>
    implements _$$AuthDTOImplCopyWith<$Res> {
  __$$AuthDTOImplCopyWithImpl(
      _$AuthDTOImpl _value, $Res Function(_$AuthDTOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? role = null,
    Object? isVerified = null,
  }) {
    return _then(_$AuthDTOImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as Role,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthDTOImpl implements _AuthDTO {
  const _$AuthDTOImpl(
      {required this.id,
      required this.email,
      this.role = const Role(name: 'patient'),
      @JsonKey(name: 'is_verified') this.isVerified = false});

  factory _$AuthDTOImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthDTOImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  @JsonKey()
  final Role role;
  @override
  @JsonKey(name: 'is_verified')
  final bool isVerified;

  @override
  String toString() {
    return 'AuthDTO(id: $id, email: $email, role: $role, isVerified: $isVerified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthDTOImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, role, isVerified);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthDTOImplCopyWith<_$AuthDTOImpl> get copyWith =>
      __$$AuthDTOImplCopyWithImpl<_$AuthDTOImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthDTOImplToJson(
      this,
    );
  }
}

abstract class _AuthDTO implements AuthDTO {
  const factory _AuthDTO(
      {required final String id,
      required final String email,
      final Role role,
      @JsonKey(name: 'is_verified') final bool isVerified}) = _$AuthDTOImpl;

  factory _AuthDTO.fromJson(Map<String, dynamic> json) = _$AuthDTOImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  Role get role;
  @override
  @JsonKey(name: 'is_verified')
  bool get isVerified;
  @override
  @JsonKey(ignore: true)
  _$$AuthDTOImplCopyWith<_$AuthDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
