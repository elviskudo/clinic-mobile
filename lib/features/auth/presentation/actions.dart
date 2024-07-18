import 'package:clinic/features/profile/presentation/actions.dart';
import 'package:clinic/services/kv.dart';
import 'package:rearch/rearch.dart';

import '../data/auth_repo.dart';
import '../domain/credential.dart';

(Credential?, void Function(Credential?)) cachedCredential(CapsuleHandle use) {
  return use.state<Credential?>(null);
}

Future<Credential?> fetchCredential(CapsuleHandle use) async {
  final (cached, _) = use(cachedCredential);
  final (_, setProfile) = use(cachedProfile);

  final repo = use(authRepo);

  if (cached != null) return cached;

  final (cred, profile) = await repo.getCredential();
  setProfile(profile);

  return cred;
}

Future<void> Function({
  required String email,
  required String name,
  required String phone,
  required String password,
}) signupAction(CapsuleHandle use) {
  final (_, set) = use(cachedCredential);
  final repo = use(authRepo);

  return ({
    required String email,
    required String name,
    required String phone,
    required String password,
  }) async {
    final cred = await repo.signup(
      email: email,
      name: name,
      phone: phone,
      password: password,
    );
    set(cred);
  };
}

Future<Credential> Function({
  required String email,
  required String password,
}) signinAction(CapsuleHandle use) {
  final (_, set) = use(cachedCredential);
  final repo = use(authRepo);

  return ({
    required String email,
    required String password,
  }) async {
    final cred = await repo.signin(email: email, password: password);
    set(cred);

    return cred;
  };
}

Future<void> Function() signoutAction(CapsuleHandle use) {
  final (_, setCred) = use(cachedCredential);
  final (_, setProfile) = use(cachedProfile);

  final repo = use(authRepo);

  return () async {
    await repo.signout();
    await KV.auth.delete('access_token');

    setCred(null);
    setProfile(null);
  };
}

Future<Credential> Function(String) emailVerificationAction(CapsuleHandle use) {
  final (_, set) = use(cachedCredential);
  final repo = use(authRepo);

  return (String code) async {
    final cred = await repo.emailVerification(code: code);
    set(cred);

    return cred;
  };
}

Future<void> resendEmailVerificationCodeAction(CapsuleHandle use) async {
  final repo = use(authRepo);

  await repo.resendEmailVerificationCode();
}
