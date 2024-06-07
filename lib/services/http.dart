import 'package:clinic/services/kv.dart';
import 'package:dio/dio.dart';

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

final dio = Dio(_opts)..interceptors.addAll(_interceptors);
