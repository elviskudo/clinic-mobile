import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_profile_response.freezed.dart';
part 'get_profile_response.g.dart';

@freezed
class GetProfileResponse with _$GetProfileResponse {
  const factory GetProfileResponse({
    GetProfileResponseData? data,
  }) = _GetProfileResponse;

  factory GetProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$GetProfileResponseFromJson(json);
}

@freezed
class GetProfileResponseData with _$GetProfileResponseData {
  const factory GetProfileResponseData({
    required GetProfileResponseDataUser user,
  }) = _GetProfileResponseData;

  factory GetProfileResponseData.fromJson(Map<String, dynamic> json) =>
      _$GetProfileResponseDataFromJson(json);
}

@freezed
class GetProfileResponseDataUser with _$GetProfileResponseDataUser {
  const factory GetProfileResponseDataUser({
    required int id,
    @JsonKey(name: 'full_name') required String fullName,
    String? image,
    required String email,
    @JsonKey(name: 'phone_number') required String phoneNumber,
    @JsonKey(name: 'verifikasi') required bool isVerified,
  }) = _GetProfileResponseDataUser;

  factory GetProfileResponseDataUser.fromJson(Map<String, dynamic> json) =>
      _$GetProfileResponseDataUserFromJson(json);
}
