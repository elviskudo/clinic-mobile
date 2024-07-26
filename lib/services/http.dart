import 'dart:io';

import 'package:clinic/services/kv.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: dotenv.get('API_BASE_URL'),
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 5),
    receiveDataWhenStatusError: true,
  ),
)
  ..httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      final HttpClient client = HttpClient(
        context: SecurityContext(withTrustedRoots: false),
      );
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return client;
    },
  )
  ..interceptors.addAll(
    [LogInterceptor(), TokenInterceptor()],
  );

class TokenInterceptor extends Interceptor {
  TokenInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final token = KV.auth.get('access_token');
    if (token != null) {
      options.headers = {
        'Authorization': 'Bearer $token',
      };
    }

    super.onRequest(options, handler);
  }
}
