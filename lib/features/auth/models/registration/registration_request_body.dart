import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_request_body.freezed.dart';
part 'registration_request_body.g.dart';

@freezed
class RegistrationRequestBody with _$RegistrationRequestBody {
  const factory RegistrationRequestBody({
    required String email,
    required String password,
    @JsonKey(name: 'fullname') required String fullName,
    @JsonKey(name: 'phone_number') required String phoneNumber,
  }) = _RegistrationRequestBody;

  factory RegistrationRequestBody.fromJson(Map<String, dynamic> json) =>
      _$RegistrationRequestBodyFromJson(json);
}
