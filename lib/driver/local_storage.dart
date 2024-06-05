import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> getStorage() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  // await prefs.setString('app_theme', 'light');
  return prefs;
}

FlutterSecureStorage getSecureStorage() {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
}
