part of 'view.dart';

(Profile?, void Function(Profile?)) _cachedProfile(CapsuleHandle use) {
  return use.state<Profile?>(null);
}

Future<Profile?> fetchProfile(CapsuleHandle use) async {
  final (cached, _) = use(_cachedProfile);

  try {
    if (cached != null) return cached;

    final json = KV.auth.get('profile');
    final profile = json != null
        ? Profile.fromJson(jsonDecode(json) as Map<String, dynamic>)
        : null;

    return profile;
  } catch (ex) {
    debugPrint('$ex');
    return null;
  }
}
