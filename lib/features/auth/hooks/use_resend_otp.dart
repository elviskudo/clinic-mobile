import 'dart:async';

import 'package:clinic/services/toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../services/auth.dart';

UseResendOtp useResendOtp(BuildContext context, WidgetRef ref) {
  final cooldown = useState(60);
  final enabled = useState(false);

  useEffect(() {
    final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (cooldown.value != 0) {
        cooldown.value--;
      } else {
        enabled.value = true;
      }
    });

    return () => timer.cancel();
  }, [enabled.value, cooldown.value]);

  return UseResendOtp(
    context: context,
    ref: ref,
    enabled: enabled,
    cooldown: cooldown,
  );
}

class UseResendOtp {
  const UseResendOtp({
    required BuildContext context,
    required WidgetRef ref,
    required ValueNotifier<bool> enabled,
    required ValueNotifier<int> cooldown,
  })  : _ref = ref,
        _context = context,
        _cooldown = cooldown,
        _enabled = enabled;

  final BuildContext _context;
  final WidgetRef _ref;

  final ValueNotifier<bool> _enabled;
  final ValueNotifier<int> _cooldown;

  bool get enabled => _enabled.value;
  int get cooldown => _cooldown.value;

  void handleSubmit() async {
    toast(_context.tr('resend_sending'));

    _cooldown.value = 60;
    _enabled.value = false;

    await _ref
        .read(authServiceProvider)
        .resendOtp()
        .then((_) => toast(_context.tr('resend_notice')))
        .catchError((_) => toast(_context.tr('resend_error_notice')));
  }
}
