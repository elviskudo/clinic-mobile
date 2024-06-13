import 'package:clinic/providers/profile.dart';
import 'package:clinic/services/http.dart';
import 'package:dio/dio.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

typedef ChangeAvatarMutationFn = Mutation<String, DioException, XFile>;

ChangeAvatarMutationFn useChangeAvatar(BuildContext context, WidgetRef ref) {
  final mutation = useMutation<String, DioException, XFile, dynamic>(
    'profile/change_avatar',
    (file) async {
      final data = FormData.fromMap({
        'profil_image' '': await MultipartFile.fromFile(
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
    onData: (data, recoveryType) {
      if (data.isNotEmpty) {
        final profile = ref.read(profileNotifierProvider);
        ref
            .read(profileNotifierProvider.notifier)
            .set(profile?.copyWith(imageUrl: data));
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
