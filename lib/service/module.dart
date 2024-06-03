import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../driver/http.dart';
import '../driver/local_storage.dart';

@module
abstract class GlobalKeyModule {
  @lazySingleton
  GlobalKey<ScaffoldMessengerState> get toast =>
      GlobalKey<ScaffoldMessengerState>();
}

@module
abstract class DriverModule {
  @lazySingleton
  Dio get dio => getHTTPDriver();

  @preResolve
  Future<SharedPreferences> get storage => getStorage();

  @lazySingleton
  FlutterSecureStorage get secureStorage => getSecureStorage();

  @lazySingleton
  Connectivity get connectivity => Connectivity();
}
