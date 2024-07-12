import 'package:clinic/features/auth/domain/credential.dart';
import 'package:clinic/features/profile/domain/profile.dart';
import 'package:clinic/services/isar.dart';
import 'package:clinic/services/local_store.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar/isar.dart';
import 'package:state_beacon/state_beacon.dart';

import '../domain/auth_repo.dart';

class AuthRepoLocal implements AuthRepo {
  AuthRepoLocal({
    required Isar store,
    required FlutterSecureStorage prefs,
  })  : _store = store,
        _prefs = prefs;

  final Isar _store;
  final FlutterSecureStorage _prefs;

  @override
  Future<Credential?> getCredential() async {
    if ((await _prefs.read(key: 'x-access-token')) == null) return null;
    return await _store.credentials.where(distinct: true).findFirst();
  }

  @override
  Future<Credential> signIn({
    required String email,
    required String password,
  }) async {
    final cred = await getCredential();

    if (cred == null) throw Exception('User not found');

    final res = await _store.credentials
        .where(distinct: true)
        .filter()
        .emailEqualTo(email)
        .findFirst();

    await _prefs.write(key: 'x-access-token', value: 'secrettoken');

    return res!;
  }

  @override
  Future<Credential> signUp({
    required String email,
    required String name,
    required String phone,
    required String password,
  }) async {
    final cred = await getCredential();

    if (cred != null) throw Exception('User was already registerd');

    final res = await _store.writeTxn(() async {
      await Future.wait([
        _store.credentials.put(Credential(email: email)),
        _store.profiles.put(
          Profile(
            fullName: name,
            phoneNumber: phone,
            avatar: 'https://api.dicebear.com/8.x/notionists/svg?seed=$name',
          ),
        )
      ]);

      return Credential(email: email);
    });

    await _prefs.write(key: 'x-access-token', value: 'secrettoken');

    return res;
  }

  @override
  Future<void> changePassword({
    required String password,
    required String confirmationPassword,
  }) async {
    await _prefs.delete(key: 'x-access-token');
  }

  @override
  Future<Credential> emailVerification(String code) async {
    final cred = await getCredential();

    if (cred == null) throw Exception('User not found');

    final newCred = cred.copyWith(isVerified: true);
    await _store.credentials.put(newCred);
    return newCred;
  }

  @override
  Future<void> resendEmailVerificationCode() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<void> signOut() async {
    await _prefs.delete(key: 'x-access-token');
  }
}

final authRepo = Ref.scoped(
  (context) => AuthRepoLocal(
    store: isar.read(context),
    prefs: localStore.instance,
  ),
);
