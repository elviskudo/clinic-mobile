import 'package:clinic/models/profile/profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_http_response.freezed.dart';
part 'profile_http_response.g.dart';

@freezed
class ProfileHttpResponse with _$ProfileHttpResponse {
  const factory ProfileHttpResponse({ProfileHttpResponseData? data}) =
      _ProfileHttpResponse;

  factory ProfileHttpResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileHttpResponseFromJson(json);
}

@freezed
class ProfileHttpResponseData with _$ProfileHttpResponseData {
  const factory ProfileHttpResponseData({
    required Profile user,
    String? token,
  }) = _ProfileHttpResponseData;

  factory ProfileHttpResponseData.fromJson(Map<String, dynamic> json) =>
      _$ProfileHttpResponseDataFromJson(json);
}
