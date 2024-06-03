import 'package:flutter/material.dart';

import '../../../../constants/sizes.dart';
import '../../../../l10n/widgets/dropdown_button.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
        title: Text(
          'Logo',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontFamily: 'CalSans'),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: Sizes.p16),
            child: IntrinsicWidth(child: L10nDropdownButton()),
          ),
        ],
      ),
      body: body,
    );
  }
}
