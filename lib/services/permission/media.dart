import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media.g.dart';

@riverpod
class MediaPermission extends _$MediaPermission {
  @override
  FutureOr<bool> build() async {
    final camera = await Permission.camera.isGranted;
    final storage = await Permission.storage.isGranted;
    final photos = await Permission.photos.isGranted;

    return camera && (storage || photos);
  }

  void ask({FutureOr<void> Function()? onGranted}) async {
    final camera = await Permission.camera.request();
    late PermissionStatus image;

    bool isCompat = await _checkAndroidLatestCompat();
    if (isCompat) {
      image = await Permission.photos.request();
    } else {
      image = await Permission.storage.request();
    }

    state = AsyncData([camera, image].every((val) => val.isGranted));

    if (state.requireValue && onGranted != null) {
      await onGranted();
    }
  }

  Future<bool> _checkAndroidLatestCompat() async {
    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      return info.version.sdkInt > 32;
    }
    return false;
  }
}
