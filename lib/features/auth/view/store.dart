part of 'view.dart';

(Credential?, void Function(Credential?)) _cachedCredential(CapsuleHandle use) {
  return use.state<Credential?>(null);
}

(AsyncValue<Credential?>, void Function()) cred$(CapsuleHandle use) {
  final fetch = use(fetchCredential);
  final (cached, setCached) = use(_cachedCredential);

  return use.refreshableFuture(() async {
    if (cached != null) return cached;

    final remote = await fetch;
    setCached(remote);

    return remote;
  });
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
