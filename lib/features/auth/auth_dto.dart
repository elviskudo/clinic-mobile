import 'package:clinic/features/user/user_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_dto.freezed.dart';
part 'auth_dto.g.dart';

@freezed
class AuthDTO with _$AuthDTO {
  const factory AuthDTO({
    required String id,
    required String email,
    @Default(Role(name: 'patient')) Role role,
    @Default(false) @JsonKey(name: 'is_verified') bool isVerified,
  }) = _AuthDTO;

  factory AuthDTO.fromJson(Map<String, dynamic> json) =>
      _$AuthDTOFromJson(json);
}
