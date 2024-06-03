import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/sizes.dart';

part 'token.dart';

@Injectable()
@lazySingleton
class AppTheme with ChangeNotifier {
  late ThemeMode _state;
  final SharedPreferences _prefs;

  AppTheme({required SharedPreferences prefs}) : _prefs = prefs {
    final storedTheme = _prefs.getString('app_theme');

    if (storedTheme == 'light') {
      _state = ThemeMode.light;
    } else if (storedTheme == 'dark') {
      _state = ThemeMode.dark;
    } else {
      _state = ThemeMode.system;
    }
  }

  ThemeMode get mode => _state;

  void set(ThemeMode mode) {
    _prefs.setString('app_theme', mode.name);

    _state = mode;
    notifyListeners();
  }
}
