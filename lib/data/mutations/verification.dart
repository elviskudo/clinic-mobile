import 'dart:async';

import 'package:clinic/models/profile/profile_http_response.dart';
import 'package:clinic/services/http.dart';
import 'package:clinic/services/kv.dart';
import 'package:clinic/services/toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

VerificationMutationProps useAccountVerification(BuildContext context) {
  final otp = useState<List<String>>([]);
  final error = useState('');

  final mutation = useMutation<void, dynamic, String, dynamic>(
    'auth/verification',
    (reqBody) async {
      final res = await dio.post('/api/auth/verification', data: reqBody);

      if (res.statusCode == 201 || res.statusCode == 200) {
        final result = ProfileHttpResponse.fromJson(res.data).data;
        final token = result?.token ?? '';
        final profile = result?.user;

        if (token.isNotEmpty && profile != null) {
          await KV.tokens.put('access_token', token);
          return;
        }
      }
    },
    onData: (result, recovery) {
      context.go('/');
    },
    onError: (error, recoveryData) {
      debugPrint('$error');
      context.replace('/verification');
      toast(context.tr('verification_error'));
    },
    refreshQueries: ['profile'],
  );

  return VerificationMutationProps(
    error: error,
    otp: otp,
    mutation: mutation,
  );
}

class VerificationMutationProps {
  const VerificationMutationProps({
    required ValueNotifier<String?> error,
    required ValueNotifier<List<String>> otp,
    required Mutation<void, dynamic, String> mutation,
  })  : _mutation = mutation,
        _otp = otp,
        _error = error;

  final ValueNotifier<String?> _error;
  final ValueNotifier<List<String>> _otp;
  final Mutation<void, dynamic, String> _mutation;

  String get error => _error.value ?? '';
  String get otp => _otp.value.isEmpty ? '' : _otp.value.join('');

  bool get hasError => error.isNotEmpty;
  bool get isLoading => _mutation.isMutating;

  void handleCodeChange(String code) {
    if (error.isNotEmpty) {
      _error.value = '';
    }
    _otp.value.add(code);
  }

  void handleSubmit(BuildContext context, {String? value}) async {
    _error.value = '';
    if (otp.isEmpty || otp.length < 6) {
      _error.value = context.tr('verification_empty');
    } else {
      await _mutation.mutate(value ?? otp);
    }
  }
}

ResendProps useResendOTP() {
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

  return ResendProps(
    enabled: enabled,
    cooldown: cooldown,
  );
}

class ResendProps {
  const ResendProps({
    required ValueNotifier<bool> enabled,
    required ValueNotifier<int> cooldown,
  })  : _cooldown = cooldown,
        _enabled = enabled;

  final ValueNotifier<bool> _enabled;
  final ValueNotifier<int> _cooldown;

  bool get enabled => _enabled.value;
  int get cooldown => _cooldown.value;

  void submit(BuildContext context) async {
    _cooldown.value = 60;
    _enabled.value = false;

    await dio
        .post('/api/auth/resend')
        .then((_) => toast(context.tr('resend_notice')))
        .catchError((_) => toast(context.tr('resend_error_notice')));
  }
}
