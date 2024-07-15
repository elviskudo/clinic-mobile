part of 'view.dart';

AsyncValue<Profile?> profile$(CapsuleHandle use) {
  final fetch = use(fetchProfile);
  return use.future(fetch);
}

(String?, String) fullName$(CapsuleHandle use) {
  final profile = use(profile$);
  return (
    switch (profile) {
      AsyncData(:final data) => data?.fullName,
      _ => null,
    },
    'John Doe'
  );
}

(String?, String) avatar$(CapsuleHandle use) {
  final profile = use(profile$);
  return (
    switch (profile) {
      AsyncData(:final data) => data?.avatar,
      _ => null,
    },
    'https://api.dicebear.com/8.x/notionists/svg?seed=johndoe'
  );
}

(String?, String) profileText$(CapsuleHandle use) {
  final profile = use(profile$);
  return (
    switch (profile) {
      AsyncData(:final data) =>
        data != null ? profileToText(profile: data).join(', ') : '',
      _ => null
    },
    'Personal data lengkap.'
  );
}
