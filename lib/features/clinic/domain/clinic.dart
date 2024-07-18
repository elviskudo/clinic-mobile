import 'package:freezed_annotation/freezed_annotation.dart';

part 'clinic.freezed.dart';
part 'clinic.g.dart';

@freezed
class Clinic with _$Clinic {
  @JsonSerializable()
  const factory Clinic({
    required String id,
    required String name,
  }) = _Clinic;
  factory Clinic.fromJson(Map<String, dynamic> json) => _$ClinicFromJson(json);
}
