import 'dart:io';

import 'package:clinic/services/kv.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class TokenInterceptor extends Interceptor {
  TokenInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final token = KV.tokens.get('access_token');
    if (token != null) {
      options.headers = {
        'Authorization': 'Bearer $token',
      };
    }

    super.onRequest(options, handler);
  }
}

final _opts = BaseOptions(
  baseUrl: 'https://clever-betta-optimis-007f52a5.koyeb.app',
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(minutes: 1),
  receiveDataWhenStatusError: true,
);

final _interceptors = [
  LogInterceptor(),
  TokenInterceptor(),
];

final dio = Dio(_opts)
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
  ..interceptors.addAll(_interceptors);
