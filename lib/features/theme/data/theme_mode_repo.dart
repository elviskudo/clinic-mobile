import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../drivers/local_storage.dart';

part 'theme_mode_repo.g.dart';

class ThemeModeRepository {
  ThemeModeRepository(this.storage) {
    _init();
  }

  final SharedPreferences storage;

  void _init() async {
    final mode = storage.getString('theme-mode');
    if (mode == null) {
      await setMode(ThemeMode.system);
    }
  }

  ThemeMode get mode {
    final mode = storage.getString('theme-mode');

    if (mode == 'light') {
      return ThemeMode.light;
    } else if (mode == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    await storage.setString('theme-mode', mode.name);
  }
}

@riverpod
ThemeModeRepository themeMode(ThemeModeRef ref) {
  final prefs = ref.read(sharedStorageProvider);
  return ThemeModeRepository(prefs);
}
