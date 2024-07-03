import 'package:freezed_annotation/freezed_annotation.dart';

part 'city.freezed.dart';
part 'city.g.dart';

@freezed
class City with _$City {
  const City._();

  const factory City({
    required int id,
    @JsonKey(name: 'kabupaten') required String name,
    @JsonKey(name: 'kecamatan') required String district,
    @JsonKey(name: 'kelurahan') required String regency,
  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

  String get text => '$regency - $district, $name';
}
