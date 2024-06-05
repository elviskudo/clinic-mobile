import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_response.freezed.dart';
part 'verification_response.g.dart';

@freezed
class VerificationResponse with _$VerificationResponse {
  const factory VerificationResponse({VerificationResponseData? data}) =
      _VerificationResponse;

  factory VerificationResponse.fromJson(Map<String, dynamic> json) =>
      _$VerificationResponseFromJson(json);
}

@freezed
class VerificationResponseData with _$VerificationResponseData {
  const factory VerificationResponseData({
    required VerificationResponseDataUser user,
  }) = _VerificationResponseData;

  factory VerificationResponseData.fromJson(Map<String, dynamic> json) =>
      _$VerificationResponseDataFromJson(json);
}

@freezed
class VerificationResponseDataUser with _$VerificationResponseDataUser {
  const factory VerificationResponseDataUser({
    required String token,
  }) = _VerificationResponseDataUser;

  factory VerificationResponseDataUser.fromJson(Map<String, dynamic> json) =>
      _$VerificationResponseDataUserFromJson(json);
}
