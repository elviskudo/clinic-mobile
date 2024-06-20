import 'package:freezed_annotation/freezed_annotation.dart';

part 'clinic.freezed.dart';
part 'clinic.g.dart';

@freezed
class Clinic with _$Clinic {
  const factory Clinic({
    int? id,
    @JsonKey(name: 'clinic_name') required String name,
    String? description,
    String? address,
    @JsonKey(name: 'post_code') String? zipCode,
  }) = _Clinic;

  factory Clinic.fromJson(Map<String, dynamic> json) => _$ClinicFromJson(json);
}
