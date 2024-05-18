import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'drivers/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  // await prefs.clear();

  runApp(
    ProviderScope(
      overrides: [sharedStorageProvider.overrideWithValue(prefs)],
      child: const MainApp(),
    ),
  );
}
