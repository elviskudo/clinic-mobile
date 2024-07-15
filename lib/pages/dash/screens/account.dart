import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/features/auth/auth.dart';
import 'package:clinic/features/profile/profile.dart';
import 'package:clinic/services/theme.dart';
import 'package:clinic/ui/l10n/l10n_list_tile.dart';
import 'package:clinic/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(top: Sizes.p8),
          shrinkWrap: true,
          children: const [
            _AccountScreenHeader(),
            gapH8,
            Divider(),
            gapH24,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.p24),
              child: UncompleteProfileNotice(),
            ),
            gapH24,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.p24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ThemeListTile(),
                  L10nListTile(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountScreenHeader extends StatelessWidget {
  const _AccountScreenHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: const PhotoProfile(),
            title: RearchBuilder(
              builder: (context, use) {
                final (name, placeholder) = use(fullName$);
                return Skeletonizer(
                  enabled: name == null,
                  child: AutoSizeText(
                    name ?? placeholder,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w500),
                    minFontSize: 14,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
            subtitle: RearchBuilder(
              builder: (context, use) {
                final (email, placeholder) = use(email$);
                return Skeletonizer(
                  enabled: email == null,
                  child: AutoSizeText(
                    email ?? placeholder,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Theme.of(context).hintColor),
                    minFontSize: 10,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
            trailing: const RoleChip(),
            enableFeedback: false,
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(left: 56),
              child: Text(
                'Go to your account settings',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          gapH8,
        ],
      ),
    );
  }
}
