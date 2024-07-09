import 'package:clinic/constants/sizes.dart';
import 'package:clinic/features/auth/hooks/use_credential.dart';
import 'package:clinic/features/user/hooks/use_profile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'photo_profile.dart';
import 'role_chip.dart';

class DashboardHeader extends HookWidget implements PreferredSizeWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cred = useCredential(context);
    final profile = useProfile();

    return Padding(
      padding: const EdgeInsets.only(top: Sizes.p16),
      child: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: Sizes.p8),
          child: Row(
            children: [
              Skeletonizer(
                enabled: profile.isLoading || cred.isLoading,
                child: GestureDetector(
                  onTap: () {
                    context.push('/account/settings');
                  },
                  child: PhotoProfile(url: profile.data?.avatar),
                ),
              ),
              gapW16,
              Skeletonizer(
                enabled: profile.isLoading || cred.isLoading,
                child: RoleChip(
                  role: cred.data?.role.name ?? context.tr('patient'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(0, 64);
}
