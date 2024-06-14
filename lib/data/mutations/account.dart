import 'dart:async';

import 'package:clinic/providers/profile.dart';
import 'package:clinic/services/http.dart';
import 'package:clinic/services/kv.dart';
import 'package:clinic/services/toast.dart';
import 'package:clinic/widgets/modal_dialog_busy.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

typedef ChangeAvatarMutationFn = Mutation<String, DioException, XFile>;

ChangeAvatarMutationFn useChangeAvatar(BuildContext context, WidgetRef ref) {
  final mutation = useMutation<String, DioException, XFile, dynamic>(
    'profile/change_avatar',
    (file) async {
      final data = FormData.fromMap({
        'profil_image': await MultipartFile.fromFile(
          file.path,
          filename: file.name,
        ),
      });

      final res = await dio.put('/api/users/update/avatar', data: data);

      if (res.statusCode == 201 || res.statusCode == 200) {
        return res.data['data']['user']['image'];
      }

      return '';
    },
    refreshQueries: ['profile'],
    onMutate: (_) async {
      await showBusyDialog(context);
    },
    onData: (data, recoveryType) {
      if (data.isNotEmpty) {
        final profile = ref.read(profileNotifierProvider);
        ref
            .read(profileNotifierProvider.notifier)
            .set(profile?.copyWith(imageUrl: data));
      }

      if (context.canPop()) {
        context.pop();
      }
    },
    onError: (e, recoveryType) {
      debugPrint(
        '[change_avatar_mutation] ${e.response!.statusCode} - ${e.response!.data.toString()}',
      );
    },
  );

  return mutation;
}

typedef ChangePasswordMutationFn
    = Mutation<void, DioException, Map<String, dynamic>>;

ChangePasswordMutationFn useChangePassword(BuildContext context, WidgetRef ref,
    {FutureOr<void> Function()? onData}) {
  return useMutation(
    "profile/change_password",
    (reqBody) async {
      final res = await dio.post('/api/users/change-password', data: reqBody);

      if (res.statusCode == 201 || res.statusCode == 200) {
        await KV.tokens.delete('access_token');
      }
    },
    onMutate: (_) async {
      await showBusyDialog(context);
    },
    onData: (data, recoveryType) async {
      ref.read(profileNotifierProvider.notifier).set(null);
      context.go('/');
      if (onData != null) {
        await onData();
      }
    },
    onError: (e, recoveryType) {
      debugPrint(
        '[change_password_mutation] ${e.response!.statusCode} - ${e.response!.data.toString()}',
      );
      context.replace('/account/credential');
      toast(context.tr('change_password_error'));
    },
  );
}
