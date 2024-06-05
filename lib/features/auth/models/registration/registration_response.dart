import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_response.freezed.dart';
part 'registration_response.g.dart';

@freezed
class RegistrationResponse with _$RegistrationResponse {
  const factory RegistrationResponse({RegistrationResponseData? data}) =
      _RegistrationResponse;

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$RegistrationResponseFromJson(json);
}

@freezed
class RegistrationResponseData with _$RegistrationResponseData {
  const factory RegistrationResponseData({
    required RegistrationResponseDataUser user,
  }) = _RegistrationResponseData;

  factory RegistrationResponseData.fromJson(Map<String, dynamic> json) =>
      _$RegistrationResponseDataFromJson(json);
}

@freezed
class RegistrationResponseDataUser with _$RegistrationResponseDataUser {
  const factory RegistrationResponseDataUser({
    required int id,
    @JsonKey(name: 'fullname') required String fullName,
    required String token,
  }) = _RegistrationResponseDataUser;

  factory RegistrationResponseDataUser.fromJson(Map<String, dynamic> json) =>
      _$RegistrationResponseDataUserFromJson(json);
}
