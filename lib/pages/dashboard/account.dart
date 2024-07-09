import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/constants/sizes.dart';
import 'package:clinic/features/auth/hooks/use_credential.dart';
import 'package:clinic/features/user/hooks/use_profile.dart';
import 'package:clinic/services/kv.dart';
import 'package:clinic/widgets/cards/uncomplete_profile_notice.dart';
import 'package:clinic/widgets/l10n/l10n_setting_list_tile.dart';
import 'package:clinic/widgets/photo_profile.dart';
import 'package:clinic/widgets/role_chip.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AccountPage extends HookWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cred = useCredential(context);
    final profile = useProfile();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(Sizes.p24).copyWith(top: 0),
        shrinkWrap: true,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(0).copyWith(top: Sizes.p16),
            leading: Skeletonizer(
              enabled: profile.isLoading || cred.isLoading,
              child: PhotoProfile(url: profile.data?.avatar),
            ),
            title: Skeletonizer(
              enabled: profile.isLoading || cred.isLoading,
              child: AutoSizeText(
                profile.data?.fullName ?? 'John Doe',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w500),
                minFontSize: 14,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            subtitle: Skeletonizer(
              enabled: profile.isLoading || cred.isLoading,
              child: AutoSizeText(
                cred.data?.email ?? 'john@acme.inc',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Theme.of(context).hintColor),
                minFontSize: 10,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: Skeletonizer(
              enabled: profile.isLoading || cred.isLoading,
              child: RoleChip(
                role: cred.data?.role.name ?? context.tr('patient'),
              ),
            ),
            enableFeedback: false,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Skeletonizer(
              enabled: profile.isLoading || cred.isLoading,
              child: GestureDetector(
                onTap: profile.isLoading || cred.isLoading
                    ? null
                    : () {
                        context.push('/account/settings');
                      },
                child: Text(
                  context.tr('account_settings_link'),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: Sizes.p16),
            child: Divider(),
          ),
          const UncompleteProfileNotice(),
          gapH16,
          ValueListenableBuilder(
            valueListenable: KV.isDarkMode.listenable(),
            builder: (context, box, _) {
              final darkMode = box.get('dark_mode', defaultValue: false)!;
              return ListTile(
                dense: true,
                leading: PhosphorIcon(
                  darkMode
                      ? PhosphorIconsRegular.moon
                      : PhosphorIconsRegular.sun,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(context.tr('dark_mode')),
                subtitle: Text(darkMode ? 'On' : 'Off'),
                trailing: Switch(
                  value: darkMode,
                  onChanged: (value) {
                    box.put('dark_mode', value);
                  },
                ),
              );
            },
          ),
          gapH16,
          const L10nSettingListTile(),
        ],
      ),
    );
  }
}
