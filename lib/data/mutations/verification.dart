import 'dart:async';

import 'package:clinic/models/profile/profile_http_response.dart';
import 'package:clinic/services/http.dart';
import 'package:clinic/services/kv.dart';
import 'package:clinic/services/toast.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

typedef VerificationMutationFn
    = Mutation<void, DioException, Map<String, dynamic>>;

VerificationMutationProps useAccountVerification(BuildContext context) {
  final key = useMemoized(() => GlobalKey<FormState>());

  final otp = useTextEditingController.fromValue(TextEditingValue.empty);

  final mutation =
      useMutation<void, DioException, Map<String, dynamic>, dynamic>(
    'auth/verification',
    (reqBody) async {
      debugPrint('[verification_mutation]: ${reqBody.toString()}');
      final res = await dio.post('/api/auth/verification', data: reqBody);

      debugPrint('[verification_response] ${res.data.toString()}');

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
      // TODO: success notice - showModalBottomSheet
    },
    onError: (e, recoveryData) {
      debugPrint(
        '[verification_mutation] ${e.response!.statusCode} - ${e.response!.data.toString()}',
      );
      // context.go('/');
      context.replace('/verification');
      toast(context.tr('verification_error'));
    },
    refreshQueries: ['profile'],
  );

  return VerificationMutationProps(
    key: key,
    otp: otp,
    mutation: mutation,
  );
}

class VerificationMutationProps {
  const VerificationMutationProps({
    required this.key,
    required this.otp,
    required VerificationMutationFn mutation,
  }) : _mutation = mutation;

  final GlobalKey<FormState> key;
  final TextEditingController otp;
  final VerificationMutationFn _mutation;

  bool get isLoading => _mutation.isMutating;

  void handleSubmit(BuildContext context, {String? pin}) async {
    if (key.currentState!.validate()) {
      await _mutation.mutate({'kode_otp': pin ?? otp.text});
    }
    key.currentState!.reset();
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

  void handleSubmit(BuildContext context) async {
    toast(context.tr('resend_sending'));

    _cooldown.value = 60;
    _enabled.value = false;

    await dio.post('/api/auth/resend').then((_) {
      toast(context.tr('resend_notice'));
    }).catchError((e) {
      debugPrint(
        '[resend_otp] ${e.response!.statusCode} - ${e.response!.data.toString()}',
      );
      toast(context.tr('resend_error_notice'));
    });
  }
}
