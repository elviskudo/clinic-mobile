import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/constants/sizes.dart';
import 'package:clinic/features/user/hooks/use_profile.dart';
import 'package:clinic/widgets/cards/uncomplete_profile_notice.dart';
import 'package:clinic/widgets/dashboard_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = useProfile();

    return Scaffold(
      appBar: const DashboardHeader(),
      body: ListView(
        padding: const EdgeInsets.all(Sizes.p24),
        shrinkWrap: true,
        children: [
          Skeletonizer(
            enabled: profile.isLoading || !profile.hasData,
            child: AutoSizeText(
              context.tr(
                'home_greet_title',
                namedArgs: {
                  'name': profile.data?.fullName ?? 'John Doe',
                  'clinic': 'Mayou Clinic',
                },
              ),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.w600),
              minFontSize: 16,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          gapH8,
          Skeletonizer(
            enabled: profile.isLoading || !profile.hasData,
            child: Text(context.tr('home_greet_desc')),
          ),
          gapH24,
          const UncompleteProfileNotice(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: Sizes.p16),
        child: FloatingActionButton(
          onPressed: profile.isLoading ? null : () {},
          elevation: 2,
          child: const PhosphorIcon(
            PhosphorIconsRegular.calendarPlus,
          ),
        ),
      ),
    );
  }
}
