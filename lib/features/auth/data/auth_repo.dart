import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../drivers/http_client.dart';
import '../../../drivers/local_storage.dart';
import 'models/auth_cred.dart';

part 'auth_repo.g.dart';

class AuthRepository {
  AuthRepository({
    required Dio dio,
    required FlutterSecureStorage prefs,
  })  : _dio = dio,
        _prefs = prefs;

  final FlutterSecureStorage _prefs;
  final Dio _dio;

  FutureOr<bool> authenticate() async {
    await _prefs.write(
      key: 'auth_token',
      value: 'super_secret_api_access_token',
    );
    return true;
  }

  Future<String?> getToken() => _prefs.read(key: 'auth_token');

  Future<AuthCredential?> getCurrentCredential() async {
    final accessToken = await getToken();
    if (accessToken == null) return null;

    final res = await _dio.get('/api/users/profiles');

    if (res.statusCode! >= 400) return null;

    final cred = AuthCredential(
        userId: res.data['data']['user']['id'],
        isVerified: res.data['data']['user']['verifikasi'],
        fullName: res.data['data']['user']['full_name']);

    return cred;
  }

  FutureOr<AuthCredential> signup(
    Map<String, dynamic> data,
  ) async {
    final res = await _dio.post('/api/auth/register', data: data);

    final token = res.data['data']['user']['token'];
    final cred = AuthCredential(
      userId: res.data['data']['user']['id'],
      isVerified: false,
      fullName: res.data['data']['user']['fullname'],
    );

    await _prefs.write(key: 'auth_token', value: token);

    return cred;
  }

  FutureOr<AuthCredential> signin(
    Map<String, dynamic> data,
  ) async {
    final res = await _dio.post('/api/auth/signin', data: data);

    final token = res.data['data']['token'];
    final cred = AuthCredential(
      userId: res.data['data']['user_id'],
      isVerified: res.data['data']['verifikasi'],
      fullName: res.data['data']['fullname'],
    );

    await _prefs.write(key: 'auth_token', value: token);

    return cred;
  }

  FutureOr<AuthCredential> verify(
    Map<String, dynamic> data,
    AuthCredential current,
  ) async {
    final accessToken = await getToken();

    if (accessToken == null) {
      throw DioException(requestOptions: RequestOptions());
    }

    final res = await _dio.post('/api/auth/verification', data: data);

    await _prefs.write(
      key: 'auth_token',
      value: res.data['data']['user']['token'],
    );

    return current.copyWith(isVerified: true);
  }

  FutureOr<void> resendOtp() async {
    final accessToken = await getToken();

    if (accessToken == null) {
      throw DioException(requestOptions: RequestOptions());
    }

    await _dio.post('/api/auth/resend');
  }
}

@riverpod
AuthRepository authRepo(AuthRepoRef ref) => AuthRepository(
      dio: ref.watch(dioProvider),
      prefs: ref.watch(secureStorageProvider),
    );
