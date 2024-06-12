import 'package:clinic/constants/sizes.dart';
import 'package:clinic/providers/profile.dart';
import 'package:clinic/widgets/auth/sign_out_list_tile.dart';
import 'package:clinic/widgets/user/photo_profile.dart';
import 'package:clinic/widgets/user/role_chip.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AccountSettingsScreen extends HookConsumerWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('account_settings'))),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(Sizes.p24),
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const RoleChip(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Sizes.p16),
                child: PhotoProfile(
                  onPressed: () {},
                  url: profile?.imageUrl,
                  size: 40,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  context.tr('page_account_settings.change_profile_photo'),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: Sizes.p16),
            child: Divider(),
          ),
          ListTile(
            dense: true,
            onTap: () {},
            leading: PhosphorIcon(
              PhosphorIconsRegular.userList,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(context.tr('profile_tile_title')),
            subtitle: Text(context.tr('profile_tile_subtitle')),
            trailing: PhosphorIcon(
              PhosphorIconsRegular.caretRight,
              color: Theme.of(context).hintColor,
            ),
          ),
          gapH16,
          ListTile(
            dense: true,
            onTap: () {},
            leading: PhosphorIcon(
              PhosphorIconsRegular.key,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(context.tr('account_tile_title')),
            subtitle: Text(context.tr('account_tile_subtitle')),
            trailing: PhosphorIcon(
              PhosphorIconsRegular.caretRight,
              color: Theme.of(context).hintColor,
            ),
          ),
          gapH16,
          ListTile(
            dense: true,
            enabled: false,
            leading: PhosphorIcon(
              PhosphorIconsRegular.bellRinging,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(context.tr('notifications_tile_title')),
            trailing: PhosphorIcon(
              PhosphorIconsRegular.caretRight,
              color: Theme.of(context).hintColor,
            ),
          ),
          gapH16,
          const SignOutListTile(),
        ],
      ),
    );
  }
}
