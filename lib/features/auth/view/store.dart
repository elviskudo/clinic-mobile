part of 'view.dart';

Credential? _cachedCredential(CapsuleHandle _) => null;

(AsyncValue<Credential?>, void Function()) cred$(CapsuleHandle use) {
  final fetch = use(fetchCredential);
  final cached = use(_cachedCredential);
  return use.refreshableFuture(() async => cached ?? await fetch);
}

(String?, String) email$(CapsuleHandle use) {
  final (profile, _) = use(cred$);
  return (
    switch (profile) {
      AsyncData(:final data) => data?.email,
      _ => null,
    },
    'Loading'
  );
}

(String?, String) role$(CapsuleHandle use) {
  final (cred, _) = use(cred$);
  return (
    switch (cred) {
      AsyncData(:final data) => data?.role?.name,
      _ => null,
    },
    'Loading'
  );
}
