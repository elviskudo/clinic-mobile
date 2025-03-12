import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final _isDarkMode = false.obs;
  final _key = 'isDarkMode';

  bool get isDarkMode => _isDarkMode.value;
  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  // Memuat nilai tema dari SharedPreferences
  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDarkMode = prefs.getBool(_key) ?? false;
    _isDarkMode.value = savedDarkMode;
    _applyTheme();
  }

  // Menyimpan nilai tema ke SharedPreferences
  Future<void> _saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, _isDarkMode.value);
  }

  // Toggle tema antara light dan dark mode
  Future<void> toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;
    await _saveThemeToPrefs();
    _applyTheme();
  }

  // Menerapkan tema ke seluruh aplikasi
  void _applyTheme() {
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}

// Kelas untuk tema aplikasi
class AppTheme {
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF35693E),
    scaffoldBackgroundColor: Color(0xFFF7FBF2),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFFF7FBF2),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF181D18)),
      titleTextStyle: TextStyle(
        color: Color(0xFF181D18),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: Color(0xFF35693E),
      secondary: Color(0xFF39656D),
      surface: Colors.white,
      background: Color(0xFFF7FBF2),
      error: Colors.red.shade900,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Color(0xFFC1C9BE), width: 1),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.black,
      thickness: 1,
    ),
    iconTheme: IconThemeData(
      color: Color(0xFF181D18),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF181D18)),
      bodyMedium: TextStyle(color: Color(0xFF181D18)),
      displayLarge: TextStyle(color: Color(0xFF181D18)),
      displayMedium: TextStyle(color: Color(0xFF181D18)),
      displaySmall: TextStyle(color: Color(0xFF181D18)),
      headlineMedium: TextStyle(color: Color(0xFF181D18)),
      headlineSmall: TextStyle(color: Color(0xFF181D18)),
      titleLarge: TextStyle(color: Color(0xFF181D18)),
      titleMedium: TextStyle(color: Color(0xFF181D18)),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF4B9460),
    scaffoldBackgroundColor: Color(0xFF2c313c),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF2c313c),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF4B9460),
      secondary: Color(0xFF64B0BC),
      surface: Color(0xFF2c313c),
      background: Color(0xFF2c313c),
      error: Colors.red.shade200,
    ),
    cardTheme: CardTheme(
      color: Color(0xFF1b1b1b),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Color(0xFF2C2C2C), width: 1),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.white,
      thickness: 1,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      displayLarge: TextStyle(color: Colors.white),
      displayMedium: TextStyle(color: Colors.white),
      displaySmall: TextStyle(color: Colors.white),
      headlineMedium: TextStyle(color: Colors.white),
      headlineSmall: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
    ),
  );
}
