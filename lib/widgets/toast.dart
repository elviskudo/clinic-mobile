import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../constants/sizes.dart';

final GlobalKey<ScaffoldMessengerState> toaster =
    GlobalKey<ScaffoldMessengerState>();

enum ToastType { loading, error, info, plain }

SnackBar toast(String message, {ToastType type = ToastType.plain}) {
  return SnackBar(
    content: Row(
      children: [
        if (type == ToastType.info) ...[
          const PhosphorIcon(PhosphorIconsRegular.info)
        ] else if (type == ToastType.error) ...[
          const PhosphorIcon(PhosphorIconsRegular.warning)
        ] else if (type == ToastType.loading) ...[
          const CircularProgressIndicator()
        ] else ...[
          const SizedBox.shrink()
        ],
        gapW8,
        Flexible(child: Text(message)),
      ],
    ),
  );
}
