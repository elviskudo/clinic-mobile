import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/theme/theme.dart';
import 'drivers/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors
  registerErrorHandlers();

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedStorageProvider.overrideWith((ref) => sharedPreferences),
      ],
      child: const MainApp(),
    ),
  );
}

void registerErrorHandlers() {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint(error.toString());
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      backgroundColor: MaterialTheme.lightScheme().errorContainer,
      body: Center(
        child: Text(
          details.toString(),
          style: TextStyle(
            color: MaterialTheme.lightScheme().onErrorContainer,
          ),
        ),
      ),
    );
  };
}
