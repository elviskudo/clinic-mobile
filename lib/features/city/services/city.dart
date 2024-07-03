import 'package:clinic/services/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/city.dart';

part 'city.g.dart';

class CityService {
  Future<List<City>> getCities(String q) async {
    if (q.isEmpty) return [];

    final res = await dio.get<Map<String, dynamic>>(
      '/api/v2/cities',
      queryParameters: {
        'q': q,
        'page': 1,
        'limit': 10,
        'order': 'asc',
      },
    );

    return List.from(res.data!['data'])
        .map((json) => City.fromJson(json))
        .toList();
  }
}

@riverpod
CityService cityService(CityServiceRef ref) => CityService();
