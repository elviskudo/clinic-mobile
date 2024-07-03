import 'package:clinic/features/city/city.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'biodata.freezed.dart';
part 'biodata.g.dart';

@freezed
class Biodata with _$Biodata {
  const Biodata._();

  const factory Biodata({
    int? id,
    @JsonKey(name: 'fullname') String? fullName,
    @JsonKey(name: 'birth_place') String? placeOfBirth,
    @JsonKey(name: 'birth_date') DateTime? dateOfBirth,
    String? gender,
    @JsonKey(name: 'no_identity') String? nik,
    String? address,
    @JsonKey(name: 'area_code') String? postalCode,
    @JsonKey(name: 'responsible_for_costs') String? responsibleForCosts,
    @JsonKey(name: 'blood_type') String? bloodType,
    City? city,
  }) = _Biodata;

  String? get dateOfBirthStr => dateOfBirth != null
      ? DateFormat('dd/MM/yyyy').format(dateOfBirth!)
      : null;

  String? get cityStr => city?.text;

  factory Biodata.fromJson(Map<String, dynamic> json) =>
      _$BiodataFromJson(json);
}
