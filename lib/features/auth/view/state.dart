import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_repo.dart';

part 'state.g.dart';

@Riverpod(keepAlive: true)
FutureOr<bool> isAuthenticated(IsAuthenticatedRef ref) async {
  final hasToken = await ref
      .read(authRepoProvider)
      .getToken()
      .then((token) => token != null);

  return hasToken;
}
