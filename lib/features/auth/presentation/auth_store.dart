import 'package:clinic/features/auth/auth.dart';
import 'package:state_beacon/state_beacon.dart';

import '../data/auth_repo_local.dart';

class AuthStore extends BeaconController {
  AuthStore({required AuthRepo repo}) : _repo = repo;

  final AuthRepo _repo;

  ReadableBeacon<AsyncValue<Credential?>> get cred$ => _cred;
  late final _cred = B.writable<AsyncValue<Credential?>>(
    AsyncIdle(),
  );

  Future<Credential?> refresh() async {
    _cred.value = AsyncLoading();
    final cred = await _repo.getCredential().catchError((_) => null);
    _cred.value = AsyncData(cred);
    return cred;
  }

  ReadableBeacon<String?> get email$ => _email;
  late final _email = B.derived(() => _cred.value.unwrapOrNull()?.email);

  Future<void> signIn({required String email, required String password}) async {
    _cred.value = AsyncLoading();
    try {
      final cred = await _repo.signIn(email: email, password: password);
      _cred.value = AsyncData(cred);
    } catch (ex) {
      _cred.value = AsyncError(ex);
      rethrow;
    }
  }

  Future<void> signOut() async {
    _cred.value = AsyncLoading();
    await _repo.signOut();
    _cred.value = AsyncData(null);
  }

  Future<void> signUp({
    required String email,
    required String name,
    required String phone,
    required String password,
  }) async {
    _cred.value = AsyncLoading();
    try {
      final cred = await _repo.signUp(
        email: email,
        name: name,
        phone: phone,
        password: password,
      );
      _cred.value = AsyncData(cred);
    } catch (ex) {
      _cred.value = AsyncError(ex);
      rethrow;
    }
  }

  Future<void> emailVerification(String code) async {
    _cred.value = AsyncLoading();
    try {
      final cred = await _repo.emailVerification(code);
      _cred.value = AsyncData(cred);
    } catch (ex) {
      _cred.value = AsyncError(ex);
      rethrow;
    }
  }
}

final auth$ = Ref.scoped(
  (context) => AuthStore(
    repo: authRepo.read(context),
  ),
);
