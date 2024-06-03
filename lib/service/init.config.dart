// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:clinic/l10n/l10n.dart' as _i8;
import 'package:clinic/service/module.dart' as _i10;
import 'package:clinic/theme/theme.dart' as _i9;
import 'package:connectivity_plus/connectivity_plus.dart' as _i7;
import 'package:dio/dio.dart' as _i5;
import 'package:flutter/material.dart' as _i4;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i3;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final driverModule = _$DriverModule();
    final globalKeyModule = _$GlobalKeyModule();
    await gh.factoryAsync<_i3.SharedPreferences>(
      () => driverModule.storage,
      preResolve: true,
    );
    gh.lazySingleton<_i4.GlobalKey<_i4.ScaffoldMessengerState>>(
        () => globalKeyModule.toast);
    gh.lazySingleton<_i5.Dio>(() => driverModule.dio);
    gh.lazySingleton<_i6.FlutterSecureStorage>(
        () => driverModule.secureStorage);
    gh.lazySingleton<_i7.Connectivity>(() => driverModule.connectivity);
    gh.factory<_i8.AppL10n>(
        () => _i8.AppL10n(prefs: gh<_i3.SharedPreferences>()));
    gh.factory<_i9.AppTheme>(
        () => _i9.AppTheme(prefs: gh<_i3.SharedPreferences>()));
    return this;
  }
}

class _$DriverModule extends _i10.DriverModule {}

class _$GlobalKeyModule extends _i10.GlobalKeyModule {}
