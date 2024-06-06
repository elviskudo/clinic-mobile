import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    required int id,
    required String email,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'image') String? imageUrl,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'verifikasi') @Default(false) bool isVerified,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
