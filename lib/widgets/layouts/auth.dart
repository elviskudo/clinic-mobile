import 'package:clinic/constants/sizes.dart';
import 'package:clinic/hooks/use_dark_mode.dart';
import 'package:clinic/widgets/l10n/l10n_dropdown_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:websafe_svg/websafe_svg.dart';

class AuthLayout extends HookWidget {
  const AuthLayout({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = useDarkMode().state;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(0, 64),
        child: Padding(
          padding: const EdgeInsets.only(top: Sizes.p16),
          child: AppBar(
            backgroundColor: Colors.transparent,
            scrolledUnderElevation: 0,
            forceMaterialTransparency: true,
            systemOverlayStyle: isDarkMode
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            title: Padding(
              padding: const EdgeInsets.only(left: Sizes.p8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WebsafeSvg.asset(
                    'assets/icons/clinic_ai.svg',
                    width: 24,
                    height: 24,
                  ),
                  gapW8,
                  Text(
                    'Clinic AI',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontFamily: 'CalSans'),
                  ),
                ],
              ),
            ),
            actions: const [
              IntrinsicWidth(child: L10nDropdownButton()),
              gapW24,
            ],
          ),
        ),
      ),
      body: body,
    );
  }
}
