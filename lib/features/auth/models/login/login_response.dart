import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({LoginResponseData? data}) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@freezed
class LoginResponseData with _$LoginResponseData {
  const factory LoginResponseData({
    required String token,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'verifikasi') required bool isVerified,
    @JsonKey(name: 'fullname') required String fullName,
  }) = _LoginResponseData;

  factory LoginResponseData.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDataFromJson(json);
}
