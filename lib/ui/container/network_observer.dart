import 'package:clinic/utils/sizes.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rearch/rearch.dart';

class NetworkObserver extends RearchConsumer {
  const NetworkObserver({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final network = use.stream(
      use.memo(
        () => Connectivity().onConnectivityChanged,
      ),
    );

    if (network case AsyncData(:final data)
        when data == ConnectivityResult.none) {
      return const _OfflineScreen();
    }

    return child;
  }
}

class _OfflineScreen extends StatelessWidget {
  const _OfflineScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PhosphorIcon(
              PhosphorIconsDuotone.wifiSlash,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
            gapH16,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p24),
              child: Text(
                'Looks like you are not connecting to any network.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).disabledColor),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
