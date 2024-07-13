import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  @JsonSerializable()
  const factory Profile({
    @JsonKey(name: 'fullname') required String fullName,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'profile_image') String? avatar,
    @JsonKey(name: 'no_identity') String? nik,
    @JsonKey(name: 'birth_date') DateTime? dateOfBirth,
    @JsonKey(name: 'birth_place') String? placeOfBirth,
    @JsonKey(name: 'work_in') String? workPlace,
    @JsonKey(name: 'blood_type') String? bloodType,
    @JsonKey(name: 'marital_status') String? maritalStatus,
    @JsonKey(name: 'responsible_for_costs') String? insurance,
    String? gender,
    String? address,
    String? nationality,
    String? religion,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
