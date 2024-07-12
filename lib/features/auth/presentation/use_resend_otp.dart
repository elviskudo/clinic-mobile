import 'dart:async';

import 'package:clinic/ui/notification/toast.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:toastification/toastification.dart';

import '../data/auth_repo_local.dart';

({
  int cooldown,
  bool enabled,
  Mutation<void, dynamic, Object?> mutation,
}) useResendOtp(BuildContext context) {
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

  final mutation = useMutation(
    'resend_otp',
    (_) async => await authRepo.read(context).resendEmailVerificationCode(),
    onMutate: (_) {
      context.toast.loading(
        title: 'Authentication',
        message: 'Requesting verification code...',
      );
    },
    onData: (data, _) {
      toastification.dismissAll();
      context.toast.success(
        title: 'Authentication',
        message: 'Verification code has been sent successfully.',
      );
    },
    onError: (ex, _) {
      context.toast.error(
        title: 'Authentication',
        message: 'Cannot send verification code, please try again later.',
      );
    },
  );

  return (
    cooldown: cooldown.value,
    enabled: enabled.value,
    mutation: mutation,
  );
}
