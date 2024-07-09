import 'dart:async';

import 'package:clinic/features/auth/auth_repo.dart';
import 'package:clinic/services/toast.dart';
import 'package:clinic/widgets/modals/success_bottom_sheet.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../auth_dto.dart';

typedef VerificationMutationFn = Mutation<AuthDTO, DioException, String>;

UseVerification useVerification(BuildContext context) {
  final formKey = useMemoized(() => GlobalKey<FormState>());
  final pinputController = useTextEditingController();
  final mutation = useMutation<AuthDTO, DioException, String, dynamic>(
    'verification',
    (code) async => await AuthRepository().emailVerification(code),
    refreshQueries: ['account'],
    onData: (data, _) async {
      await showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => const _VerificationSuccess(),
      );
    },
    onError: (e, recoveryData) {
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

  void submit({String? pin}) async {
    if (formKey.currentState!.validate()) {
      await _mutation.mutate(pin ?? pinputController.text);
      formKey.currentState!.reset();
    }
  }

  bool get isLoading => _mutation.isMutating;
}

class _VerificationSuccess extends HookWidget {
  const _VerificationSuccess();

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      final timer = Timer.periodic(
        const Duration(seconds: 5),
        (_) {
          context.go('/home');
          if (context.canPop()) context.pop();
        },
      );
      return () => timer.cancel();
    }, []);

    return SuccessBottomSheet(
      title: context.tr('verification_success.title'),
      subtitle: context.tr('verification_success.microcopy'),
    );
  }
}
