import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'clinic.freezed.dart';
part 'clinic.g.dart';

@freezed
@Collection(ignore: {'copyWith'})
class Clinic with _$Clinic {
  const Clinic._();

  @JsonSerializable()
  const factory Clinic({
    required String name,
  }) = _Clinic;

  Id get isarId => Isar.autoIncrement;

  factory Clinic.fromJson(Map<String, dynamic> json) => _$ClinicFromJson(json);
}
