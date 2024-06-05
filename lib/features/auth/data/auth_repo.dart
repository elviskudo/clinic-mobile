import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:native_toast/native_toast.dart';

import '../../../l10n/generated/l10n.dart';
import '../models/login/login_request_body.dart';
import '../models/login/login_response.dart';
import '../models/profile/get_profile_response.dart';
import '../models/profile/profile.dart';
import '../models/registration/registration_request_body.dart';
import '../models/registration/registration_response.dart';
import '../models/verification/verification_request_body.dart';
import '../models/verification/verification_response.dart';

@Injectable()
@lazySingleton
class AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _prefs;

  const AuthRepository({
    required FlutterSecureStorage prefs,
    required Dio dio,
  })  : _dio = dio,
        _prefs = prefs;

  Future<Profile?> getCurrentProfile() async {
    try {
      final res = await _dio.get('/api/users/profiles');
      if (res.statusCode != 200) return null;

      final user = GetProfileResponse.fromJson(res.data).data!.user;

      return Profile(
        id: user.id,
        fullName: user.fullName,
        imageUrl: user.image,
        isVerified: user.isVerified,
        email: user.email,
        phoneNumber: user.phoneNumber,
      );
    } on DioException {
      return null;
    } catch (e) {
      debugPrint('Something went wrong: $e');
      return null;
    }
  }

  Future<void> register(RegistrationRequestBody reqBody) async {
    final res = await _dio.post('/api/auth/register', data: reqBody.toJson());
    if (res.statusCode != 201) throw ('Registration failed!');

    final user = RegistrationResponse.fromJson(res.data).data!.user;
    await _prefs.write(key: 'access_token', value: user.token);
  }

  Future<void> login(LoginRequestBody reqBody) async {
    final loginRes = await _dio.post(
      '/api/auth/signin',
      data: reqBody.toJson(),
    );
    if (loginRes.statusCode != 201) throw ('Login failed!');

    final cred = LoginResponse.fromJson(loginRes.data).data!;
    await _prefs.write(key: 'access_token', value: cred.token);
  }

  Future<void> verification(VerificationRequestBody reqBody) async {
    final verificationRes = await _dio.post(
      '/api/auth/verification',
      data: reqBody.toJson(),
    );
    if (verificationRes.statusCode != 201) throw ('Verification failed!');

    final cred = VerificationResponse.fromJson(verificationRes.data).data!.user;
    await _prefs.write(key: 'access_token', value: cred.token);
  }

  void resendOtp() async {
    try {
      await NativeToast().makeText(
        message: S.current.pageVerificationResendNotice,
      );
      await _dio.post('/api/auth/resend');
    } on DioException {
      await NativeToast().makeText(message: 'Something went wrong...');
    }
  }
}
