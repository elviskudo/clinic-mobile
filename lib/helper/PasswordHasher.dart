import 'package:bcrypt/bcrypt.dart';

class PasswordHasher {
  // Constants for BCrypt configuration
  static const int _saltRounds = 6; // Standard recommendation for BCrypt rounds

  static String hashPassword(String password) {
    final salt = BCrypt.gensalt(logRounds: _saltRounds);
    return BCrypt.hashpw(password, salt);
  }

  static bool verifyPassword(String password, String hashedPassword) {
    try {
      return BCrypt.checkpw(password, hashedPassword);
    } catch (e) {
      // Jika format hash tidak valid atau error lainnya
      print('error saat verify');
      return false;
    }
  }
}
