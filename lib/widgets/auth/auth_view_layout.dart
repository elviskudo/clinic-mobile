import 'package:clinic/constants/sizes.dart';
import 'package:clinic/widgets/l10n_dropdown_button.dart';
import 'package:flutter/material.dart';

class AuthViewLayout extends StatelessWidget {
  const AuthViewLayout({super.key, required this.body});

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
