import 'package:clinic/features/auth/presentation/actions.dart';
import 'package:clinic/features/clinic/domain/clinic.dart';
import 'package:rearch/rearch.dart';

import '../data/clinic_repo.dart';

(Clinic?, void Function(Clinic?)) cachedClinic(CapsuleHandle use) {
  return use.state<Clinic?>(null);
}

Future<Clinic?> fetchClinic(CapsuleHandle use) async {
  final (cached, set) = use(cachedClinic);
  final (cred, _) = use(cachedCredential);

  final repo = use(clinicRepo);

  if (cached != null) return cached;

  final clinic = await repo.getClinicById(cred?.clinicId ?? '');
  set(clinic);

  return clinic;
}
