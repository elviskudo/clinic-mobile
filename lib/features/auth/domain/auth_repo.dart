import 'credential.dart';

abstract class AuthRepo {
  Future<Credential?> getCredential();

  Future<Credential> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<Credential> signUp({
    required String email,
    required String name,
    required String phone,
    required String password,
  });

  Future<Credential> emailVerification(String code);

  Future<void> resendEmailVerificationCode();

  Future<void> changePassword({
    required String password,
    required String confirmationPassword,
  });
}
