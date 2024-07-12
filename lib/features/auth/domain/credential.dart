import 'package:clinic/utils/hash.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'credential.freezed.dart';
part 'credential.g.dart';

@freezed
@Collection(ignore: {'copyWith'})
class Credential with _$Credential {
  const Credential._();

  @JsonSerializable()
  const factory Credential({
    String? id,
    required String email,
    @Default(Role(name: 'patient')) Role? role,
    @JsonKey(name: 'is_verified') @Default(false) bool isVerified,
  }) = _Credential;

  Id get isarId => fastHash(id!);

  factory Credential.fromJson(Map<String, dynamic> json) =>
      _$CredentialFromJson(json);
}

@freezed
@Embedded(ignore: {'copyWith'})
class Role with _$Role {
  const factory Role({
    @Default('patient') String? name,
  }) = _Role;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
}
