import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/constants/sizes.dart';
import 'package:clinic/providers/profile.dart';
import 'package:clinic/services/kv.dart';
import 'package:clinic/widgets/l10n/l10n_setting_list_tile.dart';
import 'package:clinic/widgets/user/photo_profile.dart';
import 'package:clinic/widgets/user/role_chip.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileNotifierProvider);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(Sizes.p24).copyWith(top: 0),
        shrinkWrap: true,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(0).copyWith(top: Sizes.p16),
            leading: PhotoProfile(url: profile?.imageUrl),
            title: AutoSizeText(
              profile?.fullName ?? '',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w500),
              minFontSize: 14,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: AutoSizeText(
              profile?.email ?? '',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme.of(context).hintColor),
              minFontSize: 10,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const RoleChip(),
            enableFeedback: false,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: GestureDetector(
              onTap: () {
                context.push('/account/settings');
              },
              child: Text(
                context.tr('account_settings_link'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: Sizes.p16),
            child: Divider(),
          ),
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
          ListTile(
            dense: true,
            enabled: false,
            leading: PhosphorIcon(
              PhosphorIconsRegular.clockCounterClockwise,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(context.tr('histories_tile_title')),
            subtitle: Text(context.tr('histories_tile_subtitle')),
            trailing: PhosphorIcon(
              PhosphorIconsRegular.caretRight,
              color: Theme.of(context).hintColor,
            ),
          ),
          gapH16,
          const L10nSettingListTile(),
          gapH16,
          ListTile(
            dense: true,
            enabled: false,
            leading: PhosphorIcon(
              PhosphorIconsRegular.question,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(context.tr('help_tile_title')),
            subtitle: Text(context.tr('help_tile_subtitle')),
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
              PhosphorIconsRegular.question,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(context.tr('feedback_tile_title')),
            subtitle: Text(context.tr('feedback_tile_subtitle')),
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
              PhosphorIconsRegular.chatText,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(context.tr('term_tile_title')),
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
              PhosphorIconsRegular.shieldCheck,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(context.tr('policy_tile_title')),
            trailing: PhosphorIcon(
              PhosphorIconsRegular.caretRight,
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }
}
