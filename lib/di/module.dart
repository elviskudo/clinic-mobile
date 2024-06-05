import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/env.dart';
import '../driver/http.dart';
import '../driver/local_storage.dart';
import 'locator.dart';

@module
abstract class DriverModule {
  @preResolve
  @singleton
  Future<SharedPreferences> get storage => getStorage();

  @singleton
  FlutterSecureStorage get secureStorage => getSecureStorage();

  @lazySingleton
  Dio get dio {
    var opts = BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      receiveDataWhenStatusError: true,
    );

    var interceptors = [
      LogInterceptor(),
      TokenInterceptor(storage: locator.get<FlutterSecureStorage>())
    ];

    return Dio(
      opts,
    )..interceptors.addAll(interceptors);
  }

  @singleton
  Connectivity get connectivity => Connectivity();
}
