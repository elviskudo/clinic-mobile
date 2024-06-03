import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/env.dart';

Dio getHTTPDriver() {
  final opts = BaseOptions(
    baseUrl: Env.apiBaseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    receiveDataWhenStatusError: true,
  );

  final httpDriver = Dio(opts)
    ..interceptors.addAll([
      LogInterceptor(),
      TokenInterceptor(
        storage: const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        ),
      )
    ]);

  return httpDriver;
}

class TokenInterceptor extends Interceptor {
  TokenInterceptor({required this.storage});

  final FlutterSecureStorage storage;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storage.read(key: 'auth_token');
    if (token != null) {
      options.headers = {
        'Authorization': 'Bearer $token',
      };
    }

    super.onRequest(options, handler);
  }
}
