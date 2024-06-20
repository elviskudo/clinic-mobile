import 'package:clinic/data/mutations/signout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SignOutListTile extends HookConsumerWidget {
  const SignOutListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mutation = useSignOut(context, ref: ref);

    return ListTile(
      dense: true,
      onTap: () async {
        await mutation.mutate({});
      },
      leading: PhosphorIcon(
        PhosphorIconsRegular.signOut,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(context.tr('signout_tile_title')),
      trailing: PhosphorIcon(
        PhosphorIconsRegular.caretRight,
        color: Theme.of(context).hintColor,
      ),
    );
  }
}
