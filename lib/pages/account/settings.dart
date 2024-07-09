import 'package:clinic/constants/sizes.dart';
import 'package:clinic/features/auth/hooks/use_credential.dart';
import 'package:clinic/features/auth/hooks/use_signout.dart';
import 'package:clinic/features/user/hooks/use_profile.dart';
import 'package:clinic/services/toast.dart';
import 'package:clinic/widgets/modals/media_picker_bottom_sheet.dart';
import 'package:clinic/widgets/photo_profile.dart';
import 'package:clinic/widgets/role_chip.dart';
import 'package:clinic/widgets/submit_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AccountSettingsPage extends HookConsumerWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cred = useCredential(context);
    final profile = useProfile();
    final signout = useSignout(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('account_settings'))),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(Sizes.p24),
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Skeletonizer(
                enabled: profile.isLoading || cred.isLoading,
                child: RoleChip(
                  role: cred.data?.role.name ?? context.tr('patient'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Sizes.p16),
                child: Skeletonizer(
                  enabled: profile.isLoading || cred.isLoading,
                  child: PhotoProfile(
                    onPressed: profile.isLoading || cred.isLoading
                        ? null
                        : () async {
                            await showMediaPickerBottomSheet(
                              context,
                              ref,
                            ).catchError((_) {
                              toast(context.tr('pick_media_error'));
                              return null;
                            });
                          },
                    url: profile.data?.avatar,
                    size: 48,
                  ),
                ),
              ),
              Skeletonizer(
                enabled: profile.isLoading || cred.isLoading,
                child: GestureDetector(
                  onTap: profile.isLoading || cred.isLoading
                      ? null
                      : () async {
                          await showMediaPickerBottomSheet(
                            context,
                            ref,
                          ).catchError((_) {
                            toast(context.tr('pick_media_error'));
                            return null;
                          });
                        },
                  child: Text(
                    context.tr('page_account_settings.change_profile_photo'),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
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
            onTap: profile.isLoading || cred.isLoading
                ? null
                : () {
                    // context.push('/account/personal');
                  },
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
            onTap: profile.isLoading || cred.isLoading
                ? null
                : () {
                    context.push('/account/credential');
                  },
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
          gapH24,
          SubmitButton(
            disabled: signout.isMutating || profile.isLoading || cred.isLoading,
            loading: signout.isMutating || profile.isLoading || cred.isLoading,
            onSubmit: () async {
              await signout.mutate({});
            },
            child: Text(context.tr('signout_tile_title')),
          ),
        ],
      ),
    );
  }
}
