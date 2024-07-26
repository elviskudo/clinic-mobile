import 'package:rearch/rearch.dart';

import '../domain/credential.dart';
import 'actions.dart';

AsyncValue<Credential?> cred$(CapsuleHandle use) {
  final fetch = use(fetchCredential);
  return use.future<Credential?>(fetch);
}

(String?, String) email$(CapsuleHandle use) {
  final cred = use(cred$);
  return (
    switch (cred) {
      AsyncData(:final data) => data?.email,
      _ => null,
    },
    'Loading'
  );
}

(String?, String) role$(CapsuleHandle use) {
  final cred = use(cred$);
  return (
    switch (cred) {
      AsyncData(:final data) => data?.role?.name,
      _ => null,
    },
    'Loading'
  );
}
