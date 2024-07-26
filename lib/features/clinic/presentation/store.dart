import 'package:rearch/rearch.dart';

import '../domain/clinic.dart';
import 'actions.dart';

AsyncValue<Clinic?> clinic$(CapsuleHandle use) {
  final fetch = use(fetchClinic);
  return use.future<Clinic?>(fetch);
}

(String?, String) clinicName$(CapsuleHandle use) {
  final cred = use(clinic$);
  return (
    switch (cred) {
      AsyncData(:final data) => data?.name ?? 'Clinic AI',
      _ => null,
    },
    'Loading'
  );
}
