import 'package:clinic/features/profile/domain/profile.dart';
import 'package:clinic/services/http.dart';
import 'package:clinic/services/kv.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rearch/rearch.dart';

import '../domain/credential.dart';
import '../domain/errors.dart';

class AuthRepository {
  Future<(Credential?, Profile?)> getCredential() async {
    try {
      if (KV.auth.get('access_token') == null) return (null, null);

      return await dio.get('/auth/personal-data').then(
        (json) {
          return (
            Credential.fromJson(json.data['data']),
            Profile.fromJson(json.data['data']['profile'])
          );
        },
      );
    } catch (ex) {
      debugPrint(ex.toString());
      return (null, null);
    }
  }

  Future<Credential> signin({
    required String email,
    required String password,
  }) async {
    try {
      final (cred, token) = await dio.post(
        '/auth/signin',
        data: {'email': email, 'password': password},
      ).then(
        (json) => (
          Credential.fromJson(json.data['data']),
          json.data['data']['token'],
        ),
      );

      await KV.auth.put('access_token', token);

      return cred;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) throw AuthenticationFailed();
      rethrow;
    }
  }

  Future<void> signout() async {
    await dio.post('/auth/signout');
  }

  Future<Credential> signup({
    required String email,
    required String name,
    required String phone,
    required String password,
  }) async {
    try {
      final (cred, token) = await dio.post(
        '/auth/register',
        data: {
          'email': email,
          'fullname': name,
          'phone_number': phone,
          'password': password,
        },
      ).then(
        (json) => (
          Credential.fromJson(json.data['data']),
          json.data['data']['token'],
        ),
      );

      await KV.auth.put('access_token', token);

      return cred;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) throw AuthenticationFailed();
      rethrow;
    }
  }

  Future<Credential> emailVerification({required String code}) async {
    try {
      final (cred, token) = await dio.post(
        '/auth/verification',
        data: {'kode_otp': code},
      ).then(
        (json) => (
          Credential.fromJson(json.data['data']),
          json.data['data']['token'],
        ),
      );

      await KV.auth.put('access_token', token);

      return cred;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) throw EmailVerificationFailed();
      if (e.response?.statusCode == 401) throw UnauthorizedAction();
      rethrow;
    }
  }

  Future<void> resendEmailVerificationCode() async {
    await dio.post('/auth/resend');
  }
}

AuthRepository authRepo(CapsuleHandle _) => AuthRepository();
