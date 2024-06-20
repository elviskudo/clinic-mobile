import 'package:clinic/services/toast.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/account.dart';
import '../services/auth.dart';
import '../widgets/verification_success_bottom_sheet.dart';

typedef VerificationMutationFn
    = Mutation<Account?, DioException, Map<String, dynamic>>;

UseVerification useVerification(BuildContext context, WidgetRef ref) {
  final formKey = useMemoized(() => GlobalKey<FormState>());
  final pinputController = useTextEditingController();
  final mutation =
      useMutation<Account, DioException, Map<String, dynamic>, dynamic>(
    'auth/verification',
    ref.read(authServiceProvider).verifyAccount,
    refreshQueries: ['account'],
    onMutate: (_) async {
      // await showBusyDialog(context);
    },
    onData: (data, _) async {
      // if (context.canPop()) context.pop();
      await showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => const VerificationSuccessBottomSheet(),
      );
    },
    onError: (e, recoveryData) {
      // if (context.canPop()) context.pop();
      context.replace('/verification');
      toast(context.tr('verification_error'));
    },
  );

  return UseVerification(
    context: context,
    formKey: formKey,
    mutation: mutation,
    pinputController: pinputController,
  );
}

class UseVerification {
  const UseVerification({
    required this.context,
    required this.formKey,
    required this.pinputController,
    required VerificationMutationFn mutation,
  }) : _mutation = mutation;

  final BuildContext context;

  final GlobalKey<FormState> formKey;
  final TextEditingController pinputController;
  final VerificationMutationFn _mutation;

  bool get isValid => formKey.currentState!.validate();

  String? handlePinputValidation(String? val) {
    if ((val ?? '').isEmpty || (val ?? '').length < 6) {
      return context.tr('verification_invalid');
    }
    return null;
  }

  void reset() {
    formKey.currentState!.reset();
  }

  void handleSubmit({String? pin}) async {
    if (isValid) {
      await _mutation.mutate({'kode_otp': pin ?? pinputController.text});
      reset();
    }
  }

  bool get isLoading => _mutation.isMutating;
}
