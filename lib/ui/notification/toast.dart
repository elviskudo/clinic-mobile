import 'package:flutter/material.dart';
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

ToastificationItem _toast(
  BuildContext context,
  ColorScheme colorScheme, {
  String? title,
  String? message,
  ToastType? type,
  Duration? autoCloseDuration,
}) {
  return toastification.show(
    title: title != null ? Text(title) : null,
    description: message != null ? Text(message) : null,
    type: _tostification(type ?? ToastType.info),
    autoCloseDuration: autoCloseDuration,
    closeButtonShowType: CloseButtonShowType.none,
    context: context,
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
}

typedef Toast = ({
  ToastificationItem Function({String? message, String? title}) loading,
  ToastificationItem Function({
    Duration? autoCloseDuration,
    required String message,
    String? title,
  }) info,
  ToastificationItem Function({
    Duration? autoCloseDuration,
    required String message,
    String? title,
  }) success,
  ToastificationItem Function({
    Duration? autoCloseDuration,
    required String message,
    String? title,
  }) error,
  void Function() clear,
});

extension ToastX on BuildContext {
  Toast get toast {
    return (
      loading: ({String? title, String? message}) {
        return _toast(
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
      }) {
        return _toast(
          this,
          Theme.of(this).colorScheme,
          title: title,
          message: message,
          type: ToastType.success,
          autoCloseDuration:
              autoCloseDuration ?? const Duration(milliseconds: 1500),
        );
      },
      error: ({
        String? title,
        required String message,
        Duration? autoCloseDuration,
      }) {
        return _toast(
          this,
          Theme.of(this).colorScheme,
          title: title,
          message: message,
          type: ToastType.error,
          autoCloseDuration:
              autoCloseDuration ?? const Duration(milliseconds: 1500),
        );
      },
      info: ({
        String? title,
        required String message,
        Duration? autoCloseDuration,
      }) {
        return _toast(
          this,
          Theme.of(this).colorScheme,
          title: title,
          message: message,
          type: ToastType.info,
          autoCloseDuration:
              autoCloseDuration ?? const Duration(milliseconds: 1500),
        );
      },
      clear: () {
        toastification.dismissAll();
      }
    );
  }
}
