import 'package:clinic/services/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/clinic.dart';

part 'clinic.g.dart';

class ClinicService {
  Future<Clinic> getCurrentClinic() async {
    final res = await dio.get('/api/clinics/9');
    return Clinic.fromJson(res.data['data']);
  }
}

@riverpod
ClinicService clinicService(ClinicServiceRef ref) => ClinicService();
