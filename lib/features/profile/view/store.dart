part of 'view.dart';

Profile? _cachedProfile(CapsuleHandle _) => null;

(AsyncValue<Profile?>, void Function()) profile$(CapsuleHandle use) {
  final fetch = use(fetchProfile);
  final cached = use(_cachedProfile);
  return use.refreshableFuture(() async => cached ?? await fetch);
}

(String?, String) fullName$(CapsuleHandle use) {
  final (profile, _) = use(profile$);
  return (
    switch (profile) {
      AsyncData(:final data) => data?.fullName,
      _ => null,
    },
    'John Doe'
  );
}

(String?, String) avatar$(CapsuleHandle use) {
  final (profile, _) = use(profile$);
  return (
    switch (profile) {
      AsyncData(:final data) => data?.avatar,
      _ => null,
    },
    'https://api.dicebear.com/8.x/notionists/svg?seed=johndoe'
  );
}

(String?, String) profileText$(CapsuleHandle use) {
  final (profile, _) = use(profile$);
  return (
    switch (profile) {
      AsyncData(:final data) =>
        data != null ? profileToText(profile: data).join(', ') : '',
      _ => null
    },
    'Personal data lengkap.'
  );
}
