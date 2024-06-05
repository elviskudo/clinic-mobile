import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class KV {
  KV._();

  static late Box<String> _tokensBox;

  static Future<void> initialize() async {
    const secureStorage = FlutterSecureStorage();

    final encryptionKeyString = await secureStorage.read(key: 'encrypted_keys');
    if (encryptionKeyString == null) {
      final key = Hive.generateSecureKey();
      await secureStorage.write(
        key: 'encrypted_keys',
        value: base64UrlEncode(key),
      );
    }

    final key = await secureStorage.read(key: 'encrypted_keys');
    final encryptionKeyUint8List = base64Url.decode(key!);

    _tokensBox = await Hive.openBox(
      'tokens',
      encryptionCipher: HiveAesCipher(encryptionKeyUint8List),
    );

    await Hive.initFlutter();
    await Hive.openBox('is_dark_mode');
  }

  static Box<bool> get isDarkMode => Hive.box<bool>('is_dark_mode');
  static Box<String> get tokens => _tokensBox;
}
