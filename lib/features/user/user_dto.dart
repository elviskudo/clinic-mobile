import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class Role with _$Role {
  const factory Role({
    @Default('patient') String name,
  }) = _Role;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
}

@freezed
class Profile with _$Profile {
  const factory Profile({
    @JsonKey(name: 'fullname') required String fullName,
    @JsonKey(name: 'phone_number') required String phoneNumber,
    @JsonKey(name: 'profile_image') String? avatar,
    @JsonKey(name: 'no_identity') String? nik,
    @JsonKey(name: 'birth_date') DateTime? dateOfBirth,
    @JsonKey(name: 'birth_place') String? placeOfBirth,
    @JsonKey(name: 'work_in') String? workPlace,
    @JsonKey(name: 'blood_type') String? bloodType,
    @JsonKey(name: 'marital_status') String? maritalStatus,
    String? gender,
    String? address,
    String? nationality,
    String? religion,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
