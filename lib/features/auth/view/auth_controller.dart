import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_repo.dart';
import '../data/models/auth_cred.dart';
import '../data/models/request_body.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  FutureOr<AuthCredential?> build() {
    return ref.read(authRepoProvider).getCurrentCredential();
  }

  Future<void> signup(SignupRequestBody data) async {
    state = await AsyncValue.guard(
      () async => ref.read(authRepoProvider).signup(data.toJson()),
      (err) => err is DioException,
    );
  }

  Future<void> signin(SigninRequestBody data) async {
    state = await AsyncValue.guard(
      () async => ref.read(authRepoProvider).signin(data.toJson()),
      (err) => err is DioException,
    );
  }

  Future<void> verify(VerificationRequestBody data) async {
    state = await AsyncValue.guard(
      () async =>
          ref.read(authRepoProvider).verify(data.toJson(), state.value!),
      (err) => err is DioException,
    );
  }

  Future<AsyncValue> resendOtp() async {
    return await AsyncValue.guard(
      () async => ref.read(authRepoProvider).resendOtp(),
    );
  }
}
