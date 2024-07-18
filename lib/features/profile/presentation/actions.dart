import 'package:clinic/features/auth/data/auth_repo.dart';
import 'package:rearch/rearch.dart';

import '../domain/profile.dart';

(Profile?, void Function(Profile?)) cachedProfile(CapsuleHandle use) {
  return use.state<Profile?>(null);
}

Future<Profile?> fetchProfile(CapsuleHandle use) async {
  final (cached, set) = use(cachedProfile);
  final repo = use(authRepo);

  if (cached != null) return cached;
  final (_, profile) = await repo.getCredential();
  set(profile);

  return profile;
}
