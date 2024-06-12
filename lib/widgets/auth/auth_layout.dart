import 'package:clinic/constants/sizes.dart';
import 'package:clinic/widgets/l10n/l10n_dropdown_button.dart';
import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(0, 64),
        child: Padding(
          padding: const EdgeInsets.only(top: Sizes.p16),
          child: AppBar(
            backgroundColor: Colors.transparent,
            scrolledUnderElevation: 0,
            forceMaterialTransparency: true,
            title: Padding(
              padding: const EdgeInsets.only(left: Sizes.p8),
              child: Text(
                'Logo',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontFamily: 'CalSans'),
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
