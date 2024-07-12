import 'package:auto_route/auto_route.dart';
import 'package:clinic/app_router.gr.dart';
import 'package:clinic/ui/l10n/l10n_chooser.dart';
import 'package:clinic/utils/sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

@RoutePage()
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      routes: const [
        OnboardingRoute(),
        SigninRoute(),
        SignupRoute(),
      ],
      builder: (context, child, ctrl) => Scaffold(
        appBar: const AuthPageHeader(),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(child: child),
              SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    '© 2024. All Rights Reserverd.',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: Theme.of(context).colorScheme.outline),
                  ),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.only(bottom: Sizes.p24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthPageHeader extends StatelessWidget implements PreferredSizeWidget {
  const AuthPageHeader({super.key, this.automaticallyImplyLeading = true});

  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: Sizes.p8,
      scrolledUnderElevation: 0,
      elevation: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Row(
        children: [
          Image.asset(
            'assets/images/clinic_ai.png',
            filterQuality: FilterQuality.high,
            height: 48,
          ),
          Text(
            'Clinic AI',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () => showL10nChooser(context),
          child: Chip(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(99),
              side: BorderSide(color: Theme.of(context).colorScheme.tertiary),
            ),
            backgroundColor: Theme.of(context)
                .colorScheme
                .tertiaryContainer
                .withOpacity(0.4),
            label: Row(
              children: [
                PhosphorIcon(
                  PhosphorIconsDuotone.globe,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 15,
                ),
                gapW8,
                Text(
                  context.locale.languageCode == 'id' ? 'Indonesia' : 'English',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: Theme.of(context).colorScheme.tertiary),
                ),
              ],
            ),
          ),
        ),
        gapW24,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
