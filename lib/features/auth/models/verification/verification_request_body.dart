import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_request_body.freezed.dart';
part 'verification_request_body.g.dart';

@freezed
class VerificationRequestBody with _$VerificationRequestBody {
  const factory VerificationRequestBody({
    @JsonKey(name: 'kode_otp') required String otpCode,
  }) = _VerificationRequestBody;

  factory VerificationRequestBody.fromJson(Map<String, dynamic> json) =>
      _$VerificationRequestBodyFromJson(json);
}
