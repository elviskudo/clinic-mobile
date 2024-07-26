import 'package:freezed_annotation/freezed_annotation.dart';

part 'credential.freezed.dart';
part 'credential.g.dart';

@freezed
class Credential with _$Credential {
  @JsonSerializable()
  const factory Credential({
    required String id,
    required String email,
    @Default(Role(name: 'patient')) Role? role,
    @JsonKey(name: 'is_verified') @Default(false) bool isVerified,
    @JsonKey(name: 'clinic_id') required String clinicId,
  }) = _Credential;

  factory Credential.fromJson(Map<String, dynamic> json) =>
      _$CredentialFromJson(json);
}

@freezed
class Role with _$Role {
  const factory Role({
    @Default('patient') String? name,
  }) = _Role;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
}
