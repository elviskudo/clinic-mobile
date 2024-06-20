import 'package:clinic/services/toast.dart';
import 'package:clinic/widgets/modals/media_picker_bottom_sheet.dart';
import 'package:clinic/widgets/modals/modal_dialog_busy.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth.dart';

typedef ChangeAvatarMutationFn = Mutation<String, DioException, XFile>;

void Function() useChangeAvatar(BuildContext context, WidgetRef ref) {
  final mutation = useMutation<String, DioException, XFile, dynamic>(
    'account/update_avatar',
    (data) async => ref.read(authServiceProvider).updateAvatar(data),
    refreshQueries: ['account'],
    onMutate: (_) async {
      await showBusyDialog(context);
    },
    onData: (data, _) {
      if (context.canPop()) context.pop();
      toast(context.tr('change_profile_photo_succeed'));
    },
    onError: (data, _) {
      if (context.canPop()) context.pop();
      toast(context.tr('change_profile_photo_error'));
    },
  );

  void handleSubmit() async {
    final pickedFile = await showMediaPickerBottomSheet(context, ref);

    if (pickedFile != null) {
      await mutation.mutate(pickedFile);
    } else {
      // ignore: use_build_context_synchronously
      toast(context.tr('pick_media_error'));
    }
  }

  return handleSubmit;
}
