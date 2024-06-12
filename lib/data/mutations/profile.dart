import 'package:clinic/providers/permission.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Mutation useChangeAvatar(WidgetRef ref) {
  final mutation = useMutation(
    'profile/change_avatar',
    (_) async {
      final isGranted = await ref.read(
        mediaPermissionProvider.future,
      );

      if (!isGranted) {
        ref.read(mediaPermissionProvider.notifier).ask();
      }
    },
  );

  return mutation;
}
