import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../drivers/local_storage.dart';

part 'auth_repo.g.dart';

class AuthRepository {
  AuthRepository(this.prefs);

  final FlutterSecureStorage prefs;

  Future<bool> authenticate() async {
    await _setToken('super_secret_api_access_token');
    return true;
  }

  Future<String?> getToken() => prefs.read(key: 'auth_token');

  Future<void> _setToken(String token) async {
    await prefs.write(key: 'auth_token', value: token);
  }
}

@riverpod
AuthRepository authRepo(AuthRepoRef ref) =>
    AuthRepository(ref.watch(secureStorageProvider));
