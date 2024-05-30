import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_body.g.dart';
part 'request_body.freezed.dart';

@freezed
class SigninRequestBody with _$SigninRequestBody {
  const factory SigninRequestBody({
    required String email,
    required String password,
  }) = _SigninRequestBody;

  factory SigninRequestBody.fromJson(Map<String, dynamic> json) =>
      _$SigninRequestBodyFromJson(json);
}

@freezed
class SignupRequestBody with _$SignupRequestBody {
  const factory SignupRequestBody({
    required String email,
    required String password,
    @JsonKey(name: 'fullname') required String fullName,
    @JsonKey(name: 'phone_number') required String phoneNumber,
  }) = _SignupRequestBody;

  factory SignupRequestBody.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestBodyFromJson(json);
}

@freezed
class VerificationRequestBody with _$VerificationRequestBody {
  const factory VerificationRequestBody({
    @JsonKey(name: 'kode_otp') required String code,
  }) = _VerificationRequestBody;

  factory VerificationRequestBody.fromJson(Map<String, dynamic> json) =>
      _$VerificationRequestBodyFromJson(json);
}
