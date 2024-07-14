part of 'view.dart';

Future<Profile?> fetchProfile(CapsuleHandle _) async {
  try {
    final cred = KV.auth.get('profile');
    if (cred == null) return null;
    return Profile.fromJson(jsonDecode(cred) as Map<String, dynamic>);
  } catch (ex) {
    debugPrint('$ex');
    return null;
  }
}
