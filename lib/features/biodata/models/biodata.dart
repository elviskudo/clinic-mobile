import 'package:clinic/features/city/city.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'biodata.freezed.dart';
part 'biodata.g.dart';

@freezed
class Biodata with _$Biodata {
  const factory Biodata({
    int? id,
    @JsonKey(name: 'fullname') String? fullName,
    @JsonKey(name: 'birth_place') String? placeOfBirth,
    @JsonKey(name: 'birth_date') DateTime? dateOfBirth,
    String? gender,
    @JsonKey(name: 'no_identity') String? nik,
    String? address,
    @JsonKey(name: 'area_code') int? postalCode,
    @JsonKey(name: 'responsible_for_costs') String? responsibleForCosts,
    @JsonKey(name: 'blood_type') String? bloodType,
    City? city,
  }) = _Biodata;

  factory Biodata.fromJson(Map<String, dynamic> json) =>
      _$BiodataFromJson(json);
}
