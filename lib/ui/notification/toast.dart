import 'package:flutter/material.dart';
import 'package:native_toast/native_toast.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:toastification/toastification.dart';

enum ToastType {
  success,
  error,
  info,
  loading,
}

ToastificationType _tostification(ToastType type) {
  return switch (type) {
    ToastType.info => ToastificationType.info,
    ToastType.loading => ToastificationType.info,
    ToastType.success => ToastificationType.success,
    ToastType.error => ToastificationType.error,
  };
}

Future<ToastificationItem> _toast(
  BuildContext context,
  ColorScheme colorScheme, {
  String? title,
  String? message,
  ToastType? type,
  Duration? autoCloseDuration,
}) async {
  final toast = toastification.show(
    title: title != null ? Text(title) : null,
    description: message != null ? Text(message) : null,
    type: _tostification(type ?? ToastType.info),
    autoCloseDuration: autoCloseDuration,
    closeButtonShowType: CloseButtonShowType.none,
    showProgressBar: false,
    dragToClose: false,
    style: ToastificationStyle.flat,
    applyBlurEffect: true,
    icon: switch (type) {
      ToastType.loading => const CircularProgressIndicator(),
      ToastType.success => PhosphorIcon(
          PhosphorIconsDuotone.checkCircle,
          color: colorScheme.primary,
        ),
      ToastType.error => PhosphorIcon(
          PhosphorIconsDuotone.xCircle,
          color: colorScheme.error,
        ),
      _ => PhosphorIcon(
          PhosphorIconsDuotone.info,
          color: colorScheme.tertiary,
        ),
    },
  );
  return Future.delayed(const Duration(milliseconds: 500)).then((_) => toast);
}

typedef Toast = ({
  void Function({String? message, String? title}) loading,
  void Function({
    Duration? autoCloseDuration,
    required String message,
    String? title,
  }) info,
  void Function({
    Duration? autoCloseDuration,
    required String message,
    String? title,
  }) success,
  void Function({
    Duration? autoCloseDuration,
    required String message,
    String? title,
  }) error,
  void Function() clear,
});

extension ToastX on BuildContext {
  Toast get toast {
    return (
      loading: ({String? title, String? message}) async {
        await _toast(
          this,
          Theme.of(this).colorScheme,
          title: title,
          message: message ?? 'Loading...',
          type: ToastType.loading,
        );
      },
      success: ({
        String? title,
        required String message,
        Duration? autoCloseDuration,
      }) async {
        await _toast(
          this,
          Theme.of(this).colorScheme,
          title: title,
          message: message,
          type: ToastType.success,
          autoCloseDuration:
              autoCloseDuration ?? const Duration(milliseconds: 3000),
        );
      },
      error: ({
        String? title,
        required String message,
        Duration? autoCloseDuration,
      }) async {
        await _toast(
          this,
          Theme.of(this).colorScheme,
          title: title,
          message: message,
          type: ToastType.error,
          autoCloseDuration:
              autoCloseDuration ?? const Duration(milliseconds: 3000),
        );
      },
      info: ({
        String? title,
        required String message,
        Duration? autoCloseDuration,
      }) async {
        await _toast(
          this,
          Theme.of(this).colorScheme,
          title: title,
          message: message,
          type: ToastType.info,
          autoCloseDuration:
              autoCloseDuration ?? const Duration(milliseconds: 3000),
        );
      },
      clear: () {
        toastification.dismissAll();
      }
    );
  }
}

final _toaster = NativeToast();

void nativeToast(String message) async {
  await _toaster.makeText(message: message);
}
