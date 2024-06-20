import 'package:clinic/services/kv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';

UseDarkMode useDarkMode() {
  final memoized = useMemoized(
    () => KV.isDarkMode.listenable(keys: ['dark_mode']),
  );
  final box = useValueListenable(memoized);
  return UseDarkMode(kv: box);
}

class UseDarkMode {
  UseDarkMode({required Box<bool> kv}) : _kv = kv;

  final Box<bool> _kv;

  bool get state => _kv.get('dark_mode', defaultValue: false)!;

  void handleChange(bool val) async {
    await _kv.put('dark_mode', val);
  }
}
