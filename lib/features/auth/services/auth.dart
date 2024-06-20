import 'package:clinic/services/http.dart';
import 'package:clinic/services/kv.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/account.dart';

part 'auth.g.dart';

class AuthService {
  FutureOr<Account?> getAccount() async {
    final res = await dio.get('/api/users/profiles');
    return res.statusCode == 200
        ? Account.fromJson(res.data['data']['user'])
        : null;
  }

  DioException get _placeholderError => DioException(
        requestOptions: RequestOptions(),
        response: Response(requestOptions: RequestOptions(), statusCode: 400),
      );

  FutureOr<Account> signIn(Map<String, dynamic> data) async {
    final res = await dio.post('/api/auth/signin', data: data);

    final token = res.data['data']['token'] ?? '';
    if (token.isEmpty) {
      throw _placeholderError;
    }
    await KV.tokens.put('access_token', token);

    return Account.fromJson(res.data['data']['user']);
  }

  FutureOr<Account> signUp(Map<String, dynamic> data) async {
    final res = await dio.post('/api/auth/register', data: data);

    final token = res.data['data']['token'] ?? '';
    if (token.isEmpty) throw _placeholderError;
    await KV.tokens.put('access_token', token);

    return Account.fromJson(res.data['data']['user'])
        .copyWith(isVerified: false);
  }

  FutureOr<void> signOut() async {
    await dio
        .post('/api/users/logout')
        .then((_) => KV.tokens.delete('access_token'));
  }

  FutureOr<Account> verifyAccount(Map<String, dynamic> data) async {
    final res = await dio.post('/api/auth/verification', data: data);

    final token = res.data['data']['token'] ?? '';
    if (token.isEmpty) throw _placeholderError;
    await KV.tokens.put('access_token', token);

    return Account.fromJson(res.data['data']['user'])
        .copyWith(isVerified: true);
  }

  Future<void> resendOtp() async {
    await dio.post('/api/auth/resend');
  }

  FutureOr<String> updateAvatar(XFile file) async {
    final data = FormData.fromMap({
      'profil_image': await MultipartFile.fromFile(
        file.path,
        filename: file.name,
      ),
    });
    final res = await dio.put('/api/users/update/avatar', data: data);

    return res.data['data']['user']['image'];
  }

  FutureOr<void> updatePassword(Map<String, dynamic> data) async {
    await dio
        .post('/api/users/change-password', data: data)
        .then((_) => KV.tokens.delete('access_token'));
  }
}

@riverpod
AuthService authService(AuthServiceRef ref) => AuthService();
