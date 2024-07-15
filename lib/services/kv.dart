import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class KV {
  KV._();

  static Box<bool> get isDarkMode => Hive.box<bool>('is_dark_mode');

  static late Box<String> _authBox;
  static Box<String> get auth => _authBox;

  static Future<void> ensureInitialized() async {
    const secureStorage = FlutterSecureStorage();

    await Hive.initFlutter();

    // await secureStorage.deleteAll();
    // await Hive.deleteFromDisk();

    final encryptionKeyString = await secureStorage.read(key: 'hive_box_key');
    if (encryptionKeyString == null) {
      final key = Hive.generateSecureKey();
      await secureStorage.write(
        key: 'hive_box_key',
        value: base64UrlEncode(key),
      );
    }

    final key = await secureStorage.read(key: 'hive_box_key');
    final encryptionKeyUint8List = base64Url.decode(key!);

    _authBox = await Hive.openBox<String>(
      'auth',
      encryptionCipher: HiveAesCipher(encryptionKeyUint8List),
    );

    await Hive.openBox<bool>('is_dark_mode');
  }
}
