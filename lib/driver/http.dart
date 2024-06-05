import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
